module MonoMath

using Pipe
using EzXML
using DataFrames
using DelimitedFiles
using Mustache
using JSON3

include("public/samples.jl")

function pango_view(font, text)
  withenv("FC_DEBUG"=>4) do
    name = @pipe `pango-view --font=$font -q -t $text` |>
      eachline |>
      Iterators.filter(contains("family:"), _) |>
      foldl((x,y)->y, _) |> # Keep only last element
      split(_, '"')[2]
  end
end

function fc_match(family)
    props = Dict{String,String}()
    for line in eachline(`fc-match -v $family`)
        if ':' in line
            key, value = strip.(split(line, ':'))
            push!(props, key => value)
        end
    end
    return props
end

hbflag(option) = "$(replace(String(option[1]), '_'=>'-'))=$(option[2])" 

function hbview(file, text, outfile; options...)
  flags = ["--"*hbflag(opt) for opt in options]
  run(`hb-view -o $outfile $flags $file $text`)
end

function default_shaper_list()
  if Sys.islinux()
    ["ot"]
  elseif Sys.iswindows()
    ["uniscribe", "ot"]
  elseif Sys.isapple()
    ["coretext", "ot"]
  else
    throw("Unsupported kernel: $(Sys.KERNEL)")
  end
end

function font_versions(file)
  error_stream = IOBuffer()
  doc = parsexml(read(pipeline(`ttx -y 0 -i -t head -t name -o /dev/stdout $file`, stderr=error_stream)))

  # Print unexpected lines from error stream
  seekstart(error_stream)
  for line in eachline(error_stream)
    if !startswith(line, "Dumping ") # We expect lines starting with "Dumping "
      println(line)
    end
  end

  head_version = nodecontent(findfirst("/ttFont/head/fontRevision/@value", doc))
  name_version = nodecontent(findfirst("/ttFont/name/namerecord[@nameID=5]", doc)) |> strip
  return (head=head_version, name=name_version)
end

function make_text_sample(;name, file, text, index, shaper_list, fontsize, format)
  shapers = join(shaper_list, '+')
  outdir = "public/samples/$fontsize/$(Sys.KERNEL)/$shapers/$format/$name"
  mkpath(outdir)

  options = [
             :line_space=>2
             :margin=>fontsize÷2
             :background=>"311d2f"
             :foreground=>"e6e4e5"
             :language=>"en"
             :shapers=>join(shaper_list, ",")
             :font_size=>fontsize
            ];

  # Write image
  index_str = lpad(index, 2, '0')
  outfilename = "$(index_str).$format"
  outfile = joinpath(outdir, outfilename)
  println("Writing $outfile...")
  hbview(file, text, outfile; options...)
end

function make_font_samples(;name, file, options...)
  for (index, text) in enumerate(text_samples)
    make_text_sample(;name, file, text, index, options...)
  end
end

function font_list()
  fonts = [
           "Cascadia Mono" => "fonts/Cascadia/ttf/CascadiaMono.ttf"
           "Consolas" => "fonts/Consolas-Regular.ttf"
           "DejaVu Sans Mono" => "fonts/dejavu-fonts-ttf-2.37/ttf/DejaVuSansMono.ttf"
           "Envy Code R" => "fonts/Envy Code R PR7/Envy Code R.ttf"
           "Everson Mono" => "fonts/evermono-7.0.0/Everson Mono.ttf"
           "FiraCode" => "fonts/FiraCode/ttf/FiraCode-Regular.ttf"
           # "FiraCode Retina" => "fonts/FiraCode/ttf/FiraCode-Retina.ttf"
           "FreeMono" => "fonts/FreeMono.otf"
           "Go Mono" => "fonts/Go-Mono.ttf"
           "Hack" => "fonts/Hack/ttf/Hack-Regular.ttf"
           "Inconsolata" => "fonts/Inconsolata/Inconsolata-Regular.otf"
           "Iosevka" => "fonts/iosevka/iosevka-regular.ttf"
           "JetBrains Mono" => "fonts/JetBrainsMono/ttf/JetBrainsMono-Regular.ttf"
           "JuliaMono" => "fonts/JuliaMono/JuliaMono-Regular.ttf"
           #"Menlo" => "fonts/Menlo.ttc"
           #"Monaco" => "fonts/Monaco.dfont"
           # "Cousine hinted" => "fonts/noto-fonts-20201206-phase3/hinted/ttf/Cousine/Cousine-Regular.ttf"
           "Cousine" => "fonts/noto-fonts-20201206-phase3/unhinted/ttf/Cousine/Cousine-Regular.ttf"
           # "Noto Sans Mono hinted" => "fonts/noto-fonts-20201206-phase3/hinted/ttf/NotoSansMono/NotoSansMono-Regular.ttf"
           "Noto Sans Mono" => "fonts/noto-fonts-20201206-phase3/unhinted/ttf/NotoSansMono/NotoSansMono-Regular.ttf"
           "Roboto Mono" => "fonts/RobotoMono/fonts/ttf/RobotoMono-Regular.ttf"
           "SF Mono" => "fonts/sfmono/SFMono-Regular.otf"
           "Ubuntu Mono" => "fonts/ubuntu-font-family-0.83/UbuntuMono-R.ttf"
          ]
  DataFrame(name=first.(fonts), path=last.(fonts))
end

function make_samples(; format=:svg, fontsize=14, shaper_list=default_shaper_list())
  for (name, file) in eachrow(font_list())
    make_font_samples(;name, file, format, fontsize, shaper_list)
  end
end

function sample_paths(; fontsize, os, shaper_list, format, fontname, n)
  shapers = join(shaper_list, '+')
  ["samples/$fontsize/$os/$shapers/$format/$fontname/$(lpad(i, 2, '0')).$format" for i in 1:n]
end

function make_html(; fontsize=14, os=Sys.KERNEL, shaper_list=default_shaper_list(), format=:svg, fontname="JuliaMono")
  samples = sample_paths(; fontsize, os, shaper_list, format, fontname, n=length(text_samples))
  tok = Mustache.load("index.html.template")
  str = render(tok; fonts=font_list(), samples)
  write("public/index.html", str)
  return str
end

rounded_version(v::Number) = round(v, digits=4)
rounded_version(v::AbstractString) = rounded_version(parse(Float64, v))

function parse_maj_min_patch(str)
  parts = split(str, '.')
  if length(parts) == 3
    return parse(Int, parts[1]) + parse(Int, parts[2])/100 + parse(Int, parts[3])/1000
  end
  return nothing
end

function make_font_data()
  data = Dict{String,String}()

  for (name, file) in eachrow(font_list())
    versions = font_versions(file)

    # First version in semicolon-spearated list
    name_first_version = first(split(versions.name, ';', limit=2))

    # Remove Version prefix if present
    name_value = last(split(name_first_version, "Version ", limit=2))

    head_rounded = rounded_version(versions.head)

    # Name table version: first try to parse as simple number
    name_rounded = try
      rounded_version(name_value)
    catch
      # Try to parse as x.y.z
      v = parse_maj_min_patch(name_value)
      isnothing(v) ? nothing : rounded_version(v)
    end
    println("Versions: head $head_rounded, name $name_rounded")

    same = head_rounded == name_rounded
    if same || versions.head == "0.0"
      summary = name_value
    else
      summary  = name_value * " (head table: $(versions.head))"
    end

    data[name] = summary
  end

  write("public/font-data.js", "font_data = ", JSON3.write(data))
end

function make_all()
  make_html()
  make_font_data()
  make_samples()
end
end

module MonoMath

using Pipe
using EzXML
using DataFrames
using DelimitedFiles
using Mustache
using JSON3

include("samples.jl")
include("fonts.jl")

# Find which font is actually used to render a glyph (to find fallback font)
function pango_view(font, text)
  withenv("FC_DEBUG"=>4) do
    name = @pipe `pango-view --font=$font -q -t $text` |>
      eachline |>
      Iterators.filter(contains("family:"), _) |>
      foldl((x,y)->y, _) |> # Keep only last element
      split(_, '"')[2]
  end
end

# Get fc-match data as a Dict
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

# Convert an option=>value pair to an hb-view flag (without leading --)
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

# Get list of codepoints in a font
function font_codepoints(file)
  cmap = parsexml(read(pipeline(`ttx -y 0 -i -t cmap -o /dev/stdout $file`)))
  return [parse(UInt32, m["code"]) for m in findall("/ttFont/cmap//map", cmap)]
end

# Get versions stored in the head and name tables of the given font file
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

# Filename of a sample
sample_file(index, format) = lpad(index, 2, '0') * ".$format"

# Directory and filename of a sample, relative to the public root
function sample_path(; fontsize, os, shaper_list, format, fontname, index)
  shapers = join(shaper_list, '+')
  dir = "samples/$fontsize/$os/$shapers/$format/$fontname"
  file = sample_file(index, format)
  return (dir, file)
end

function make_sample(; fontname, fontfile, text, index, shaper_list, fontsize, format)
  (dir, file) = sample_path(; fontname, index, shaper_list, fontsize, format, os=Sys.KERNEL)
  fulldir = joinpath("public", dir)
  mkpath(fulldir)

  options = [
             :line_space => 2
             :margin => fontsize ÷ 2
             :background => "311d2f"
             :foreground => "e6e4e5"
             :language => "en"
             :shapers => join(shaper_list, ",")
             :font_size => fontsize
            ];

  # Write image
  outfile = joinpath(fulldir, file)
  println("Writing $outfile...")
  hbview(fontfile, text, outfile; options...)
end

function make_font_samples(; fontname, fontfile, options...)
  for (index, (desc, text)) in enumerate(all_samples)
    make_sample(; fontname, fontfile, text, index, options...)
  end
end

function make_samples(; format=:svg, fontsize=14, shaper_list=default_shaper_list())
  # Make sample text files
  for (index, (desc, text)) in enumerate(all_samples)
    write(joinpath("public", "samples", sample_file(index, :txt)), text)
  end

  for (name, file) in eachrow(fonts)
    make_font_samples(; fontname=name, fontfile=file, format, fontsize, shaper_list)
  end
end

function make_html(; sample_indices=eachindex(text_samples), fontsize=14, os=Sys.KERNEL,
                     shaper_list=default_shaper_list(), format=:svg, fontname="JuliaMono", filename="index.html")
  args = (; fontsize, os, shaper_list, format, fontname)
  img = [joinpath(sample_path(; args..., index)...) for index in sample_indices]
  txt = [joinpath("samples", sample_file(index, :txt)) for index in sample_indices]
  desc = first.(all_samples[sample_indices])
  samples = DataFrame(; img, txt, desc)
  tok = Mustache.load("resources/$filename.template")
  str = render(tok; fonts, samples)
  write("public/$filename", str)
  return str
end

rounded_version(v::Number) = round(v, digits=4)
rounded_version(v::AbstractString) = rounded_version(parse(Float64, v))

# Convert maj.min.patch version to a single number, as used by Iosevka
function parse_maj_min_patch(str)
  parts = split(str, '.')
  if length(parts) == 3
    return parse(Int, parts[1]) + parse(Int, parts[2])/100 + parse(Int, parts[3])/1000
  end
  return nothing
end

function make_font_data()
  data = Dict{String,String}()

  for (name, file) in eachrow(fonts)
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
    println("Versions for $name: head $head_rounded, name $name_rounded")

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

  extra_indices = length(text_samples) .+ eachindex(extra_samples)
  make_html(sample_indices=extra_indices, filename="extras.html")
end

end

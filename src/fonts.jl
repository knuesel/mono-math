const font_dir = "resources/fonts"

const font_array = [
         "Cascadia Mono" => "Cascadia/ttf/CascadiaMono.ttf"
         "Consolas" => "Consolas-Regular.ttf"
         "DejaVu Sans Mono" => "dejavu-fonts-ttf-2.37/ttf/DejaVuSansMono.ttf"
         "Envy Code R" => "Envy Code R PR7/Envy Code R.ttf"
         "Everson Mono" => "evermono-7.0.0/Everson Mono.ttf"
         "FiraCode" => "FiraCode/ttf/FiraCode-Regular.ttf"
         # "FiraCode Retina" => "FiraCode/ttf/FiraCode-Retina.ttf"
         "FreeMono" => "FreeMono.otf"
         "Go Mono" => "Go-Mono.ttf"
         "Hack" => "Hack/ttf/Hack-Regular.ttf"
         "Inconsolata" => "Inconsolata/Inconsolata-Regular.otf"
         "Iosevka" => "iosevka/iosevka-regular.ttf"
         "JetBrains Mono" => "JetBrainsMono/ttf/JetBrainsMono-Regular.ttf"
         "JuliaMono" => "JuliaMono/JuliaMono-Regular.ttf"
         #"Menlo" => "Menlo.ttc"
         #"Monaco" => "Monaco.dfont"
         # "Cousine hinted" => "noto-fonts-20201206-phase3/hinted/ttf/Cousine/Cousine-Regular.ttf"
         "Cousine" => "noto-fonts-20201206-phase3/unhinted/ttf/Cousine/Cousine-Regular.ttf"
         # "Noto Sans Mono hinted" => "noto-fonts-20201206-phase3/hinted/ttf/NotoSansMono/NotoSansMono-Regular.ttf"
         "Noto Sans Mono" => "noto-fonts-20201206-phase3/unhinted/ttf/NotoSansMono/NotoSansMono-Regular.ttf"
         "Roboto Mono" => "RobotoMono/fonts/ttf/RobotoMono-Regular.ttf"
         "SF Mono" => "sfmono/SFMono-Regular.otf"
         "Ubuntu Mono" => "ubuntu-font-family-0.83/UbuntuMono-R.ttf"
        ]

const fonts = DataFrame(name=first.(font_array), path=joinpath.(font_dir, last.(font_array)))

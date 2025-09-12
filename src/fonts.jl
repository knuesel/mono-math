const font_dir = "resources/fonts"

const font_array = [
    "Cascadia Mono" => "Cascadia/otf/static/CascadiaMono-Regular.otf"
    "Consolas" => "Consolas-Regular.ttf"
    "Cousine" => "Cousine/Cousine-Regular.ttf"
    "CMU Typewriter Text" => "cm-unicode-0.6.3a/cmuntt.otf"
    "DejaVu Sans Mono" => "dejavu-fonts-ttf-2.37/ttf/DejaVuSansMono.ttf"
    "Envy Code R" => "Envy Code R PR7/Envy Code R.ttf"
    "Everson Mono" => "evermono-7.0.0/Everson Mono.ttf"
    "FiraCode" => "FiraCode/ttf/FiraCode-Regular.ttf"
    "FreeMono" => "FreeMono.otf"
    "Go Mono" => "go-image/font/gofont/ttfs/Go-Mono.ttf"
    "Hack" => "Hack/ttf/Hack-Regular.ttf"
    "Inconsolata" => "Inconsolata/Inconsolata-Regular.otf"
    "Iosevka" => "iosevka/Iosevka-Regular.ttf"
    "JetBrains Mono" => "JetBrainsMono/fonts/ttf/JetBrainsMono-Regular.ttf"
    "JuliaMono" => "JuliaMono/JuliaMono-Regular.ttf"
    "Latin Modern Mono" => "Latin_Modern-otf-2_006-12_08_2025/lmmono10-regular.otf"
    "Liberation Mono" => "liberation-fonts-ttf-2.1.5/LiberationMono-Regular.ttf"
    "Menlo" => "Menlo.ttc"
    #"Monaco" => "Monaco.dfont"
    "Monaspace Neon" => "Monaspace/Static Fonts/Monaspace Neon/MonaspaceNeon-Regular.otf"
    "Mononoki" => "mononoki/mononoki-Regular.ttf"
    "Noto Sans Mono" => "NotoSansMono-v2.014/NotoSansMono/unhinted/otf/NotoSansMono-Regular.otf"
    "Roboto Mono" => "RobotoMono-3.001/fonts/otf/RobotoMono-Regular.otf"
    "SF Mono" => "sfmono/SFMono-Regular.otf"
    "Source Code Pro" => "SourceCodePro/OTF/SourceCodePro-Regular.otf"
    "Ubuntu Sans Mono" => "UbuntuSansMono-fonts-1.006/otf/UbuntuSansMono-Regular.otf"
]

const fonts = DataFrame(
    name=first.(font_array),
    path=joinpath.(font_dir, last.(font_array)),
)

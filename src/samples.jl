const text_samples = [
   "Various math formulas, primes and common Julia operators" =>
   """
   ẋ, x⃗, x⃗̇, x͍⃡, x↑, θ, θ̂

   ∀x ∈ ℝ⁺, ∃n ∈ ℕ : n ≤ x < n+1

   𝐹(s) = ℒ{f(t)} = ∫₀᪲ ℯ⁻ˢᵗ f(t) dt

   J⃗ = ∇⃗ × H⃗, B⃗ = μ₀(M⃗ + H⃗)

   ∂ₜu - Δu*(γ₁-α)*α̂ = 0

   ¬(a ∨ b) ≡ (¬a ∧ ¬b), (a → b) ⊨ (¬b → ¬a)

   ' " ′ ″ ‴ ⁗ ‵ ‶ ‷
   => -> |> ∘ ⨟ ⋅ × ⊗ + ⊕ ≈ ∝ ~

   Mᵢ,ⱼ,ₖ  Mᵢ‚ⱼ‚ₖ  Mᵢˏⱼˏₖ  Mᵢ⸒ⱼ⸒ₖ  Mᵢˌⱼˌₖ

   ⌠  x⁴ - 5x       ⌠ ⌠ ⌠
   ⎮ ───────── dx   ⎮⃘ ⎮⃙ ⎮⃚
   ⌡  ∛(x-1)        ⌡ ⌡ ⌡
   """

   "Julia code for a Gibbs sampler" =>
   """
   # From https://discourse.julialang.org/t/50416/31

   using Distributions, Statistics

   function mc(x, iterations, μ₀ = 0., τ₀ = 1e-7, α = 0.0001, β = 0.0001)
       ∑x, n = sum(x), length(x)
       μ, τ = ∑x/n, 1/var(x)
       μₛ = rand(Normal((τ₀*μ₀ + τ*∑x)/(τ₀ + n*τ), 1/√(τ₀ + n*τ)), iterations)
       τₛ = rand(Gamma(α + n/2, 1/(β + 0.5*sum((xᵢ-μ)^2 for xᵢ in x))), iterations)
       samples = [(μ, τ); collect(zip(μₛ, τₛ))]
   end
   """

   "Julia code making heavy use of Unicode characters" =>
   """
   # From https://github.com/zygmuntszpak/MultipleViewGeometry.jl

   function cost(c::CostFunction, entity::FundamentalMatrix, 𝛉::AbstractArray,
                 𝒞::Tuple{AbstractArray, Vararg{AbstractArray}},
                 𝒟::Tuple{AbstractArray, Vararg{AbstractArray}})
       ℳ, ℳʹ = 𝒟
       Λ₁, Λ₂ = 𝒞
       Jₐₘₗ = 0.0
       N = length(𝒟[1])
       𝚲ₙ = @MMatrix zeros(4,4)
       𝐞₁ = @SVector [1.0, 0.0, 0.0]
       𝐞₂ = @SVector [0.0, 1.0, 0.0]
       index = SVector(1,2)
       @inbounds for n = 1:N
           𝚲ₙ[1:2,1:2] .=  Λ₁[n][index,index]
           𝚲ₙ[3:4,3:4] .=  Λ₂[n][index,index]
           𝐦 = hom(ℳ[n])
           𝐦ʹ= hom(ℳʹ[n])
           𝐔ₙ = (𝐦 ⊗ 𝐦ʹ)
           ∂ₓ𝐮ₙ =  [(𝐞₁ ⊗ 𝐦ʹ) (𝐞₂ ⊗ 𝐦ʹ) (𝐦 ⊗ 𝐞₁) (𝐦 ⊗ 𝐞₂)]
           𝐁ₙ =  ∂ₓ𝐮ₙ * 𝚲ₙ * ∂ₓ𝐮ₙ'
           𝚺ₙ = 𝛉' * 𝐁ₙ * 𝛉
           𝚺ₙ⁻¹ = inv(𝚺ₙ)
           Jₐₘₗ +=  𝛉' * 𝐔ₙ * 𝚺ₙ⁻¹ * 𝐔ₙ' * 𝛉
       end
       Jₐₘₗ
   end
   """


   "Lowercase letters" =>
   raw"""
   regular  a b c d e f g h i j k l m n o p q r s t u v w x y z
   \sans    𝖺 𝖻 𝖼 𝖽 𝖾 𝖿 𝗀 𝗁 𝗂 𝗃 𝗄 𝗅 𝗆 𝗇 𝗈 𝗉 𝗊 𝗋 𝗌 𝗍 𝗎 𝗏 𝗐 𝗑 𝗒 𝗓
   \tt      𝚊 𝚋 𝚌 𝚍 𝚎 𝚏 𝚐 𝚑 𝚒 𝚓 𝚔 𝚕 𝚖 𝚗 𝚘 𝚙 𝚚 𝚛 𝚜 𝚝 𝚞 𝚟 𝚠 𝚡 𝚢 𝚣
   \it      𝑎 𝑏 𝑐 𝑑 𝑒 𝑓 𝑔 ℎ 𝑖 𝑗 𝑘 𝑙 𝑚 𝑛 𝑜 𝑝 𝑞 𝑟 𝑠 𝑡 𝑢 𝑣 𝑤 𝑥 𝑦 𝑧
   \isans   𝘢 𝘣 𝘤 𝘥 𝘦 𝘧 𝘨 𝘩 𝘪 𝘫 𝘬 𝘭 𝘮 𝘯 𝘰 𝘱 𝘲 𝘳 𝘴 𝘵 𝘶 𝘷 𝘸 𝘹 𝘺 𝘻
   \scr     𝒶 𝒷 𝒸 𝒹 ℯ 𝒻 ℊ 𝒽 𝒾 𝒿 𝓀 𝓁 𝓂 𝓃 ℴ 𝓅 𝓆 𝓇 𝓈 𝓉 𝓊 𝓋 𝓌 𝓍 𝓎 𝓏
   \bf      𝐚 𝐛 𝐜 𝐝 𝐞 𝐟 𝐠 𝐡 𝐢 𝐣 𝐤 𝐥 𝐦 𝐧 𝐨 𝐩 𝐪 𝐫 𝐬 𝐭 𝐮 𝐯 𝐰 𝐱 𝐲 𝐳
   \bsans   𝗮 𝗯 𝗰 𝗱 𝗲 𝗳 𝗴 𝗵 𝗶 𝗷 𝗸 𝗹 𝗺 𝗻 𝗼 𝗽 𝗾 𝗿 𝘀 𝘁 𝘂 𝘃 𝘄 𝘅 𝘆 𝘇
   \bi      𝒂 𝒃 𝒄 𝒅 𝒆 𝒇 𝒈 𝒉 𝒊 𝒋 𝒌 𝒍 𝒎 𝒏 𝒐 𝒑 𝒒 𝒓 𝒔 𝒕 𝒖 𝒗 𝒘 𝒙 𝒚 𝒛
   \bisans  𝙖 𝙗 𝙘 𝙙 𝙚 𝙛 𝙜 𝙝 𝙞 𝙟 𝙠 𝙡 𝙢 𝙣 𝙤 𝙥 𝙦 𝙧 𝙨 𝙩 𝙪 𝙫 𝙬 𝙭 𝙮 𝙯
   \bscr    𝓪 𝓫 𝓬 𝓭 𝓮 𝓯 𝓰 𝓱 𝓲 𝓳 𝓴 𝓵 𝓶 𝓷 𝓸 𝓹 𝓺 𝓻 𝓼 𝓽 𝓾 𝓿 𝔀 𝔁 𝔂 𝔃
   \bb      𝕒 𝕓 𝕔 𝕕 𝕖 𝕗 𝕘 𝕙 𝕚 𝕛 𝕜 𝕝 𝕞 𝕟 𝕠 𝕡 𝕢 𝕣 𝕤 𝕥 𝕦 𝕧 𝕨 𝕩 𝕪 𝕫
   \frak    𝔞 𝔟 𝔠 𝔡 𝔢 𝔣 𝔤 𝔥 𝔦 𝔧 𝔨 𝔩 𝔪 𝔫 𝔬 𝔭 𝔮 𝔯 𝔰 𝔱 𝔲 𝔳 𝔴 𝔵 𝔶 𝔷
   \bfrak   𝖆 𝖇 𝖈 𝖉 𝖊 𝖋 𝖌 𝖍 𝖎 𝖏 𝖐 𝖑 𝖒 𝖓 𝖔 𝖕 𝖖 𝖗 𝖘 𝖙 𝖚 𝖛 𝖜 𝖝 𝖞 𝖟
   """

   "Uppercase letters" =>
   raw"""
   regular  A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
   \sans    𝖠 𝖡 𝖢 𝖣 𝖤 𝖥 𝖦 𝖧 𝖨 𝖩 𝖪 𝖫 𝖬 𝖭 𝖮 𝖯 𝖰 𝖱 𝖲 𝖳 𝖴 𝖵 𝖶 𝖷 𝖸 𝖹
   \tt      𝙰 𝙱 𝙲 𝙳 𝙴 𝙵 𝙶 𝙷 𝙸 𝙹 𝙺 𝙻 𝙼 𝙽 𝙾 𝙿 𝚀 𝚁 𝚂 𝚃 𝚄 𝚅 𝚆 𝚇 𝚈 𝚉
   \it      𝐴 𝐵 𝐶 𝐷 𝐸 𝐹 𝐺 𝐻 𝐼 𝐽 𝐾 𝐿 𝑀 𝑁 𝑂 𝑃 𝑄 𝑅 𝑆 𝑇 𝑈 𝑉 𝑊 𝑋 𝑌 𝑍
   \isans   𝘈 𝘉 𝘊 𝘋 𝘌 𝘍 𝘎 𝘏 𝘐 𝘑 𝘒 𝘓 𝘔 𝘕 𝘖 𝘗 𝘘 𝘙 𝘚 𝘛 𝘜 𝘝 𝘞 𝘟 𝘠 𝘡
   \scr     𝒜 ℬ 𝒞 𝒟 ℰ ℱ 𝒢 ℋ ℐ 𝒥 𝒦 ℒ ℳ 𝒩 𝒪 𝒫 𝒬 ℛ 𝒮 𝒯 𝒰 𝒱 𝒲 𝒳 𝒴 𝒵
   \bf      𝐀 𝐁 𝐂 𝐃 𝐄 𝐅 𝐆 𝐇 𝐈 𝐉 𝐊 𝐋 𝐌 𝐍 𝐎 𝐏 𝐐 𝐑 𝐒 𝐓 𝐔 𝐕 𝐖 𝐗 𝐘 𝐙
   \bsans   𝗔 𝗕 𝗖 𝗗 𝗘 𝗙 𝗚 𝗛 𝗜 𝗝 𝗞 𝗟 𝗠 𝗡 𝗢 𝗣 𝗤 𝗥 𝗦 𝗧 𝗨 𝗩 𝗪 𝗫 𝗬 𝗭
   \bi      𝑨 𝑩 𝑪 𝑫 𝑬 𝑭 𝑮 𝑯 𝑰 𝑱 𝑲 𝑳 𝑴 𝑵 𝑶 𝑷 𝑸 𝑹 𝑺 𝑻 𝑼 𝑽 𝑾 𝑿 𝒀 𝒁
   \bisans  𝘼 𝘽 𝘾 𝘿 𝙀 𝙁 𝙂 𝙃 𝙄 𝙅 𝙆 𝙇 𝙈 𝙉 𝙊 𝙋 𝙌 𝙍 𝙎 𝙏 𝙐 𝙑 𝙒 𝙓 𝙔 𝙕
   \bscr    𝓐 𝓑 𝓒 𝓓 𝓔 𝓕 𝓖 𝓗 𝓘 𝓙 𝓚 𝓛 𝓜 𝓝 𝓞 𝓟 𝓠 𝓡 𝓢 𝓣 𝓤 𝓥 𝓦 𝓧 𝓨 𝓩
   \bb      𝔸 𝔹 ℂ 𝔻 𝔼 𝔽 𝔾 ℍ 𝕀 𝕁 𝕂 𝕃 𝕄 ℕ 𝕆 ℙ ℚ ℝ 𝕊 𝕋 𝕌 𝕍 𝕎 𝕏 𝕐 ℤ
   \frak    𝔄 𝔅 ℭ 𝔇 𝔈 𝔉 𝔊 ℌ ℑ 𝔍 𝔎 𝔏 𝔐 𝔑 𝔒 𝔓 𝔔 ℜ 𝔖 𝔗 𝔘 𝔙 𝔚 𝔛 𝔜 ℨ
   \bfrak   𝕬 𝕭 𝕮 𝕯 𝕰 𝕱 𝕲 𝕳 𝕴 𝕵 𝕶 𝕷 𝕸 𝕹 𝕺 𝕻 𝕼 𝕽 𝕾 𝕿 𝖀 𝖁 𝖂 𝖃 𝖄 𝖅
   """

   "Greek letters" =>
   raw"""
   regular α β γ δ ϵ ε ζ η θ ϑ ι κ ϰ λ μ ν ξ ο π ϖ ρ ϱ σ ς τ υ ϕ φ χ ψ ω ϝ ∂ ∇
   \it     𝛼 𝛽 𝛾 𝛿 𝜖 𝜀 𝜁 𝜂 𝜃 𝜗 𝜄 𝜅 𝜘 𝜆 𝜇 𝜈 𝜉 𝜊 𝜋 𝜛 𝜌 𝜚 𝜎 𝜍 𝜏 𝜐 𝜙 𝜑 𝜒 𝜓 𝜔   𝜕 𝛻
   \bf     𝛂 𝛃 𝛄 𝛅 𝛜 𝛆 𝛇 𝛈 𝛉 𝛝 𝛊 𝛋 𝛞 𝛌 𝛍 𝛎 𝛏 𝛐 𝛑 𝛡 𝛒 𝛠 𝛔 𝛓 𝛕 𝛖 𝛟 𝛗 𝛘 𝛙 𝛚 𝟋 𝛛 𝛁
   \bsans  𝝰 𝝱 𝝲 𝝳 𝞊 𝝴 𝝵 𝝶 𝝷 𝞋 𝝸 𝝹 𝞌 𝝺 𝝻 𝝼 𝝽 𝝾 𝝿 𝞏 𝞀 𝞎 𝞂 𝞁 𝞃 𝞄 𝞍 𝞅 𝞆 𝞇 𝞈   𝞉 𝝯
   \bi     𝜶 𝜷 𝜸 𝜹 𝝐 𝜺 𝜻 𝜼 𝜽 𝝑 𝜾 𝜿 𝝒 𝝀 𝝁 𝝂 𝝃 𝝄 𝝅 𝝕 𝝆 𝝔 𝝈 𝝇 𝝉 𝝊 𝝓 𝝋 𝝌 𝝍 𝝎   𝝏 𝜵
   \bisans 𝞪 𝞫 𝞬 𝞭 𝟄 𝞮 𝞯 𝞰 𝞱 𝟅 𝞲 𝞳 𝟆 𝞴 𝞵 𝞶 𝞷 𝞸 𝞹 𝟉 𝞺 𝟈 𝞼 𝞻 𝞽 𝞾 𝟇 𝞿 𝟀 𝟁 𝟂   𝟃 𝞩
   \bb         ℽ                               ℼ

   regular Α Β Γ Δ Ε   Ζ Η Θ ϴ Ι Κ   Λ Μ Ν Ξ Ο Π   Ρ   Σ   Τ Υ Φ   Χ Ψ Ω Ϝ
   \it     𝛢 𝛣 𝛤 𝛥 𝛦   𝛧 𝛨 𝛩 𝛳 𝛪 𝛫   𝛬 𝛭 𝛮 𝛯 𝛰 𝛱   𝛲   𝛴   𝛵 𝛶 𝛷   𝛸 𝛹 𝛺
   \bf     𝚨 𝚩 𝚪 𝚫 𝚬   𝚭 𝚮 𝚯 𝚹 𝚰 𝚱   𝚲 𝚳 𝚴 𝚵 𝚶 𝚷   𝚸   𝚺   𝚻 𝚼 𝚽   𝚾 𝚿 𝛀 𝟊
   \bsans  𝝖 𝝗 𝝘 𝝙 𝝚   𝝛 𝝜 𝝝 𝝧 𝝞 𝝟   𝝠 𝝡 𝝢 𝝣 𝝤 𝝥   𝝦   𝝨   𝝩 𝝪 𝝫   𝝬 𝝭 𝝮
   \bi     𝜜 𝜝 𝜞 𝜟 𝜠   𝜡 𝜢 𝜣 𝜭 𝜤 𝜥   𝜦 𝜧 𝜨 𝜩 𝜪 𝜫   𝜬   𝜮   𝜯 𝜰 𝜱   𝜲 𝜳 𝜴
   \bisans 𝞐 𝞑 𝞒 𝞓 𝞔   𝞕 𝞖 𝞗 𝞡 𝞘 𝞙   𝞚 𝞛 𝞜 𝞝 𝞞 𝞟   𝞠   𝞢   𝞣 𝞤 𝞥   𝞦 𝞧 𝞨
   \bb         ℾ                               ℿ
   """

   "Digits, superscripts and subscripts" =>
   raw"""
   regular 0 1 2 3 4 5 6 7 8 9
   \sans   𝟢 𝟣 𝟤 𝟥 𝟦 𝟧 𝟨 𝟩 𝟪 𝟫
   \tt     𝟶 𝟷 𝟸 𝟹 𝟺 𝟻 𝟼 𝟽 𝟾 𝟿
   \bf     𝟎 𝟏 𝟐 𝟑 𝟒 𝟓 𝟔 𝟕 𝟖 𝟗
   \bsans  𝟬 𝟭 𝟮 𝟯 𝟰 𝟱 𝟲 𝟳 𝟴 𝟵
   \bb     𝟘 𝟙 𝟚 𝟛 𝟜 𝟝 𝟞 𝟟 𝟠 𝟡

   \^      A ᵃ ᵇ ᶜ ᵈ ᵉ ᶠ ᵍ ʰ ⁱ ʲ ᵏ ˡ ᵐ ⁿ ᵒ ᵖ   ʳ ˢ ᵗ ᵘ ᵛ ʷ ˣ ʸ ᶻ Z
   \^      A ᴬ ᴮ   ᴰ ᴱ   ᴳ ᴴ ᴵ ᴶ ᴷ ᴸ ᴹ ᴺ ᴼ ᴾ   ᴿ   ᵀ ᵁ ⱽ ᵂ       Z
   \_      A ₐ       ₑ     ₕ ᵢ ⱼ ₖ ₗ ₘ ₙ ₒ ₚ   ᵣ ₛ ₜ ᵤ ᵥ   ₓ     Z

   \^      A ⁰ ¹ ² ³ ⁴ ⁵ ⁶ ⁷ ⁸ ⁹ ⁺ ⁻ ⁼ ⁽ ⁾   ᵅ ᵝ ᵞ ᵟ ᵋ ᶿ ᶥ ᵠ ᶲ ᵡ Z
   \_      A ₀ ₁ ₂ ₃ ₄ ₅ ₆ ₇ ₈ ₉ ₊ ₋ ₌ ₍ ₎ ₔ   ᵦ ᵧ ᵨ         ᵩ ᵪ Z
   """

   "Operators" =>
   """
   ∀ ∁ ∂ ∃ ∄ ∅ ∆ ∇ ∈ ∉ ∊ ∋ ∌ ∍ ∎ ∏   ⨀ ⨁ ⨂ ⨃ ⨄ ⨅ ⨆ ⨇ ⨈ ⨉ ⨊ ⨋ ⨌ ⨍ ⨎ ⨏
   ∐ ∑ − ∓ ∔ ∕ ∖ ∗ ∘ ∙ √ ∛ ∜ ∝ ∞ ∟   ⨐ ⨑ ⨒ ⨓ ⨔ ⨕ ⨖ ⨗ ⨘ ⨙ ⨚ ⨛ ⨜ ⨝ ⨞ ⨟
   ∠ ∡ ∢ ∣ ∤ ∥ ∦ ∧ ∨ ∩ ∪ ∫ ∬ ∭ ∮ ∯   ⨠ ⨡ ⨢ ⨣ ⨤ ⨥ ⨦ ⨧ ⨨ ⨩ ⨪ ⨫ ⨬ ⨭ ⨮ ⨯
   ∰ ∱ ∲ ∳ ∴ ∵ ∶ ∷ ∸ ∹ ∺ ∻ ∼ ∽ ∾ ∿   ⨰ ⨱ ⨲ ⨳ ⨴ ⨵ ⨶ ⨷ ⨸ ⨹ ⨺ ⨻ ⨼ ⨽ ⨾ ⨿
   ≀ ≁ ≂ ≃ ≄ ≅ ≆ ≇ ≈ ≉ ≊ ≋ ≌ ≍ ≎ ≏   ⩀ ⩁ ⩂ ⩃ ⩄ ⩅ ⩆ ⩇ ⩈ ⩉ ⩊ ⩋ ⩌ ⩍ ⩎ ⩏
   ≐ ≑ ≒ ≓ ≔ ≕ ≖ ≗ ≘ ≙ ≚ ≛ ≜ ≝ ≞ ≟   ⩐ ⩑ ⩒ ⩓ ⩔ ⩕ ⩖ ⩗ ⩘ ⩙ ⩚ ⩛ ⩜ ⩝ ⩞ ⩟
   ≠ ≡ ≢ ≣ ≤ ≥ ≦ ≧ ≨ ≩ ≪ ≫ ≬ ≭ ≮ ≯   ⩠ ⩡ ⩢ ⩣ ⩤ ⩥ ⩦ ⩧ ⩨ ⩩ ⩪ ⩫ ⩬ ⩭ ⩮ ⩯
   ≰ ≱ ≲ ≳ ≴ ≵ ≶ ≷ ≸ ≹ ≺ ≻ ≼ ≽ ≾ ≿   ⩰ ⩱ ⩲ ⩳ ⩴ ⩵ ⩶ ⩷ ⩸ ⩹ ⩺ ⩻ ⩼ ⩽ ⩾ ⩿
   ⊀ ⊁ ⊂ ⊃ ⊄ ⊅ ⊆ ⊇ ⊈ ⊉ ⊊ ⊋ ⊌ ⊍ ⊎ ⊏   ⪀ ⪁ ⪂ ⪃ ⪄ ⪅ ⪆ ⪇ ⪈ ⪉ ⪊ ⪋ ⪌ ⪍ ⪎ ⪏
   ⊐ ⊑ ⊒ ⊓ ⊔ ⊕ ⊖ ⊗ ⊘ ⊙ ⊚ ⊛ ⊜ ⊝ ⊞ ⊟   ⪐ ⪑ ⪒ ⪓ ⪔ ⪕ ⪖ ⪗ ⪘ ⪙ ⪚ ⪛ ⪜ ⪝ ⪞ ⪟
   ⊠ ⊡ ⊢ ⊣ ⊤ ⊥ ⊦ ⊧ ⊨ ⊩ ⊪ ⊫ ⊬ ⊭ ⊮ ⊯   ⪠ ⪡ ⪢ ⪣ ⪤ ⪥ ⪦ ⪧ ⪨ ⪩ ⪪ ⪫ ⪬ ⪭ ⪮ ⪯
   ⊰ ⊱ ⊲ ⊳ ⊴ ⊵ ⊶ ⊷ ⊸ ⊹ ⊺ ⊻ ⊼ ⊽ ⊾ ⊿   ⪰ ⪱ ⪲ ⪳ ⪴ ⪵ ⪶ ⪷ ⪸ ⪹ ⪺ ⪻ ⪼ ⪽ ⪾ ⪿
   ⋀ ⋁ ⋂ ⋃ ⋄ ⋅ ⋆ ⋇ ⋈ ⋉ ⋊ ⋋ ⋌ ⋍ ⋎ ⋏   ⫀ ⫁ ⫂ ⫃ ⫄ ⫅ ⫆ ⫇ ⫈ ⫉ ⫊ ⫋ ⫌ ⫍ ⫎ ⫏
   ⋐ ⋑ ⋒ ⋓ ⋔ ⋕ ⋖ ⋗ ⋘ ⋙ ⋚ ⋛ ⋜ ⋝ ⋞ ⋟   ⫐ ⫑ ⫒ ⫓ ⫔ ⫕ ⫖ ⫗ ⫘ ⫙ ⫚ ⫛ ⫝̸ ⫝ ⫞ ⫟
   ⋠ ⋡ ⋢ ⋣ ⋤ ⋥ ⋦ ⋧ ⋨ ⋩ ⋪ ⋫ ⋬ ⋭ ⋮ ⋯   ⫠ ⫡ ⫢ ⫣ ⫤ ⫥ ⫦ ⫧ ⫨ ⫩ ⫪ ⫫ ⫬ ⫭ ⫮ ⫯
   ⋰ ⋱ ⋲ ⋳ ⋴ ⋵ ⋶ ⋷ ⋸ ⋹ ⋺ ⋻ ⋼ ⋽ ⋾ ⋿   ⫰ ⫱ ⫲ ⫳ ⫴ ⫵ ⫶ ⫷ ⫸ ⫹ ⫺ ⫻ ⫼ ⫽ ⫾ ⫿
   """


   "Letterlike and miscellanous symbols, arrows" =>
   """
   ℀ ℁ ℂ ℃ ℄ ℅ ℆ ℇ ℈ ℉ ℊ ℋ ℌ ℍ ℎ ℏ   ⦀ ⦁ ⦂ ⦃ ⦄ ⦅ ⦆ ⦇ ⦈ ⦉ ⦊ ⦋ ⦌ ⦍ ⦎ ⦏
   ℐ ℑ ℒ ℓ ℔ ℕ № ℗ ℘ ℙ ℚ ℛ ℜ ℝ ℞ ℟   ⦐ ⦑ ⦒ ⦓ ⦔ ⦕ ⦖ ⦗ ⦘ ⦙ ⦚ ⦛ ⦜ ⦝ ⦞ ⦟
   ℠ ℡ ™ ℣ ℤ ℥ Ω ℧ ℨ ℩ K Å ℬ ℭ ℮ ℯ   ⦠ ⦡ ⦢ ⦣ ⦤ ⦥ ⦦ ⦧ ⦨ ⦩ ⦪ ⦫ ⦬ ⦭ ⦮ ⦯
   ℰ ℱ Ⅎ ℳ ℴ ℵ ℶ ℷ ℸ ℹ ℺ ℻ ℼ ℽ ℾ ℿ   ⦰ ⦱ ⦲ ⦳ ⦴ ⦵ ⦶ ⦷ ⦸ ⦹ ⦺ ⦻ ⦼ ⦽ ⦾ ⦿
   ⅀ ⅁ ⅂ ⅃ ⅄ ⅅ ⅆ ⅇ ⅈ ⅉ ⅊ ⅋ ⅌ ⅍ ⅎ ⅏   ⧀ ⧁ ⧂ ⧃ ⧄ ⧅ ⧆ ⧇ ⧈ ⧉ ⧊ ⧋ ⧌ ⧍ ⧎ ⧏
   ⟀ ⟁ ⟂ ⟃ ⟄ ⟅ ⟆ ⟇ ⟈ ⟉ ⟊ ⟋ ⟌ ⟍ ⟎ ⟏   ⧐ ⧑ ⧒ ⧓ ⧔ ⧕ ⧖ ⧗ ⧘ ⧙ ⧚ ⧛ ⧜ ⧝ ⧞ ⧟
   ⟐ ⟑ ⟒ ⟓ ⟔ ⟕ ⟖ ⟗ ⟘ ⟙ ⟚ ⟛ ⟜ ⟝ ⟞ ⟟   ⧠ ⧡ ⧢ ⧣ ⧤ ⧥ ⧦ ⧧ ⧨ ⧩ ⧪ ⧫ ⧬ ⧭ ⧮ ⧯
   ⟠ ⟡ ⟢ ⟣ ⟤ ⟥ ⟦ ⟧ ⟨ ⟩ ⟪ ⟫ ⟬ ⟭ ⟮ ⟯   ⧰ ⧱ ⧲ ⧳ ⧴ ⧵ ⧶ ⧷ ⧸ ⧹ ⧺ ⧻ ⧼ ⧽ ⧾ ⧿

   ← ↑ → ↓ ↔ ↕ ↖ ↗ ↘ ↙ ↚ ↛ ↜ ↝ ↞ ↟   ⤀ ⤁ ⤂ ⤃ ⤄ ⤅ ⤆ ⤇ ⤈ ⤉ ⤊ ⤋ ⤌ ⤍ ⤎ ⤏
   ↠ ↡ ↢ ↣ ↤ ↥ ↦ ↧ ↨ ↩ ↪ ↫ ↬ ↭ ↮ ↯   ⤐ ⤑ ⤒ ⤓ ⤔ ⤕ ⤖ ⤗ ⤘ ⤙ ⤚ ⤛ ⤜ ⤝ ⤞ ⤟
   ↰ ↱ ↲ ↳ ↴ ↵ ↶ ↷ ↸ ↹ ↺ ↻ ↼ ↽ ↾ ↿   ⤠ ⤡ ⤢ ⤣ ⤤ ⤥ ⤦ ⤧ ⤨ ⤩ ⤪ ⤫ ⤬ ⤭ ⤮ ⤯
   ⇀ ⇁ ⇂ ⇃ ⇄ ⇅ ⇆ ⇇ ⇈ ⇉ ⇊ ⇋ ⇌ ⇍ ⇎ ⇏   ⤰ ⤱ ⤲ ⤳ ⤴ ⤵ ⤶ ⤷ ⤸ ⤹ ⤺ ⤻ ⤼ ⤽ ⤾ ⤿
   ⇐ ⇑ ⇒ ⇓ ⇔ ⇕ ⇖ ⇗ ⇘ ⇙ ⇚ ⇛ ⇜ ⇝ ⇞ ⇟   ⥀ ⥁ ⥂ ⥃ ⥄ ⥅ ⥆ ⥇ ⥈ ⥉ ⥊ ⥋ ⥌ ⥍ ⥎ ⥏
   ⇠ ⇡ ⇢ ⇣ ⇤ ⇥ ⇦ ⇧ ⇨ ⇩ ⇪ ⇫ ⇬ ⇭ ⇮ ⇯   ⥐ ⥑ ⥒ ⥓ ⥔ ⥕ ⥖ ⥗ ⥘ ⥙ ⥚ ⥛ ⥜ ⥝ ⥞ ⥟
   ⇰ ⇱ ⇲ ⇳ ⇴ ⇵ ⇶ ⇷ ⇸ ⇹ ⇺ ⇻ ⇼ ⇽ ⇾ ⇿   ⥠ ⥡ ⥢ ⥣ ⥤ ⥥ ⥦ ⥧ ⥨ ⥩ ⥪ ⥫ ⥬ ⥭ ⥮ ⥯
   ⟰ ⟱ ⟲ ⟳ ⟴ ⟵ ⟶ ⟷ ⟸ ⟹ ⟺ ⟻ ⟼ ⟽ ⟾ ⟿   ⥰ ⥱ ⥲ ⥳ ⥴ ⥵ ⥶ ⥷ ⥸ ⥹ ⥺ ⥻ ⥼ ⥽ ⥾ ⥿
   """

   "Miscellanous technical symbols, miscellanous symbols and arrows, geometric shapes, other symbols" =>
   """
   ⌀ ⌁ ⌂ ⌃ ⌄ ⌅ ⌆ ⌇ ⌈ ⌉ ⌊ ⌋ ⌌ ⌍ ⌎ ⌏   ⬀ ⬁ ⬂ ⬃ ⬄ ⬅ ⬆ ⬇ ⬈ ⬉ ⬊ ⬋ ⬌ ⬍ ⬎ ⬏
   ⌐ ⌑ ⌒ ⌓ ⌔ ⌕ ⌖ ⌗ ⌘ ⌙ ⌚ ⌛ ⌜ ⌝ ⌞ ⌟   ⬐ ⬑ ⬒ ⬓ ⬔ ⬕ ⬖ ⬗ ⬘ ⬙ ⬚ ⬛ ⬜ ⬝ ⬞ ⬟
   ⌠ ⌡ ⌢ ⌣ ⌤ ⌥ ⌦ ⌧ ⌨ 〈 〉 ⌫ ⌬ ⌭ ⌮ ⌯   ⬠ ⬡ ⬢ ⬣ ⬤ ⬥ ⬦ ⬧ ⬨ ⬩ ⬪ ⬫ ⬬ ⬭ ⬮ ⬯
   ⌰ ⌱ ⌲ ⌳ ⌴ ⌵ ⌶ ⌷ ⌸ ⌹ ⌺ ⌻ ⌼ ⌽ ⌾ ⌿   ⬰ ⬱ ⬲ ⬳ ⬴ ⬵ ⬶ ⬷ ⬸ ⬹ ⬺ ⬻ ⬼ ⬽ ⬾ ⬿
   ⍀ ⍁ ⍂ ⍃ ⍄ ⍅ ⍆ ⍇ ⍈ ⍉ ⍊ ⍋ ⍌ ⍍ ⍎ ⍏   ⭀ ⭁ ⭂ ⭃ ⭄ ⭅ ⭆ ⭇ ⭈ ⭉ ⭊ ⭋ ⭌ ⭍ ⭎ ⭏
   ⍐ ⍑ ⍒ ⍓ ⍔ ⍕ ⍖ ⍗ ⍘ ⍙ ⍚ ⍛ ⍜ ⍝ ⍞ ⍟   ⭐ ⭑ ⭒ ⭓ ⭔ ⭕ ⭖ ⭗ ⭘ ⭙ ⭚ ⭛ ⭜ ⭝ ⭞ ⭟
   ⍠ ⍡ ⍢ ⍣ ⍤ ⍥ ⍦ ⍧ ⍨ ⍩ ⍪ ⍫ ⍬ ⍭ ⍮ ⍯   ⭠ ⭡ ⭢ ⭣ ⭤ ⭥ ⭦ ⭧ ⭨ ⭩ ⭪ ⭫ ⭬ ⭭ ⭮ ⭯
   ⍰ ⍱ ⍲ ⍳ ⍴ ⍵ ⍶ ⍷ ⍸ ⍹ ⍺ ⍻ ⍼ ⍽ ⍾ ⍿   ⭰ ⭱ ⭲ ⭳   ⭶ ⭷ ⭸ ⭹ ⭺ ⭻ ⭼ ⭽ ⭾ ⭿
   ⎀ ⎁ ⎂ ⎃ ⎄ ⎅ ⎆ ⎇ ⎈ ⎉ ⎊ ⎋ ⎌ ⎍ ⎎ ⎏   ⮀ ⮁ ⮂ ⮃ ⮄ ⮅ ⮆ ⮇ ⮈ ⮉ ⮊ ⮋ ⮌ ⮍ ⮎ ⮏
   ⎐ ⎑ ⎒ ⎓ ⎔ ⎕ ⎖ ⎗ ⎘ ⎙ ⎚ ⎛ ⎜ ⎝ ⎞ ⎟   ⮐ ⮑ ⮒ ⮓ ⮔ ⮕  ⮗ ⮘ ⮙ ⮚ ⮛ ⮜ ⮝ ⮞ ⮟
   ⎠ ⎡ ⎢ ⎣ ⎤ ⎥ ⎦ ⎧ ⎨ ⎩ ⎪ ⎫ ⎬ ⎭ ⎮ ⎯   ⮠ ⮡ ⮢ ⮣ ⮤ ⮥ ⮦ ⮧ ⮨ ⮩ ⮪ ⮫ ⮬ ⮭ ⮮ ⮯
   ⎰ ⎱ ⎲ ⎳ ⎴ ⎵ ⎶ ⎷ ⎸ ⎹ ⎺ ⎻ ⎼ ⎽ ⎾ ⎿   ⮰ ⮱ ⮲ ⮳ ⮴ ⮵ ⮶ ⮷ ⮸ ⮹ ⮺ ⮻ ⮼ ⮽ ⮾ ⮿
   ⏀ ⏁ ⏂ ⏃ ⏄ ⏅ ⏆ ⏇ ⏈ ⏉ ⏊ ⏋ ⏌ ⏍ ⏎ ⏏   ⯀ ⯁ ⯂ ⯃ ⯄ ⯅ ⯆ ⯇ ⯈ ⯉ ⯊ ⯋ ⯌ ⯍ ⯎ ⯏
   ⏐ ⏑ ⏒ ⏓ ⏔ ⏕ ⏖ ⏗ ⏘ ⏙ ⏚ ⏛ ⏜ ⏝ ⏞ ⏟   ⯐ ⯑ ⯒ ⯓ ⯔ ⯕ ⯖ ⯗ ⯘ ⯙ ⯚ ⯛ ⯜ ⯝ ⯞ ⯟
   ⏠ ⏡ ⏢ ⏣ ⏤ ⏥ ⏦ ⏧ ⏨ ⏩ ⏪ ⏫ ⏬ ⏭ ⏮ ⏯   ⯠ ⯡ ⯢ ⯣ ⯤ ⯥ ⯦ ⯧ ⯨ ⯩ ⯪ ⯫ ⯬ ⯭ ⯮ ⯯
   ⏰ ⏱ ⏲ ⏳ ⏴ ⏵ ⏶ ⏷ ⏸ ⏹ ⏺ ⏻ ⏼ ⏽ ⏾ ⏿   ⯰ ⯱ ⯲ ⯳ ⯴ ⯵ ⯶ ⯷ ⯸ ⯹ ⯺ ⯻ ⯼ ⯽ ⯾ ⯿

   ■ □ ▢ ▣ ▤ ▥ ▦ ▧ ▨ ▩ ▪ ▫ ▬ ▭ ▮ ▯   + - < = > ^ | ~ ¬ ± × ÷
   ▰ ▱ ▲ △ ▴ ▵ ▶ ▷ ▸ ▹ ► ▻ ▼ ▽ ▾ ▿   ★ ☆ ♀ ♂ ♠ ♡ ♢ ♣ ♭ ♮ ♯
   ◀ ◁ ◂ ◃ ◄ ◅ ◆ ◇ ◈ ◉ ◊ ○ ◌ ◍ ◎ ●   ﹐ ﹑ ﹒ ﹔ ﹕ ﹖ ﹗ ﹘ ﹙ ﹚ ﹛ ﹜ ﹝ ﹞ ﹟
   ◐ ◑ ◒ ◓ ◔ ◕ ◖ ◗ ◘ ◙ ◚ ◛ ◜ ◝ ◞ ◟   ﹠ ﹡ ﹢ ﹣ ﹤ ﹥ ﹦ ﹨ ﹩ ﹪ ﹫
   ◠ ◡ ◢ ◣ ◤ ◥ ◦ ◧ ◨ ◩ ◪ ◫ ◬ ◭ ◮ ◯   ＋ ＜ ＝ ＞ ＼ ＾ ｜ ～ ￢   ￩ ￪ ￫ ￬   ﬩
   ◰ ◱ ◲ ◳ ◴ ◵ ◶ ◷ ◸ ◹ ◺ ◻ ◼ ◽ ◾ ◿   ‖ ′ ″ ‴ ⁀ ⁄ ⁒ ϐ ϑ ϒ ϕ ϰ ϱ ϴ ϵ ϶
   """

   "Arabic mathematical symbols" =>
   """
   𞸀	𞸁	𞸂	𞸃		𞸅	𞸆	𞸇	𞸈	𞸉	𞸊	𞸋	𞸌	𞸍	𞸎	𞸏
   𞸐	𞸑	𞸒	𞸓	𞸔	𞸕	𞸖	𞸗	𞸘	𞸙	𞸚	𞸛	𞸜	𞸝	𞸞	𞸟
   	𞸡	𞸢		𞸤			𞸧		𞸩	𞸪	𞸫	𞸬	𞸭	𞸮	𞸯
   𞸰	𞸱	𞸲		𞸴	𞸵	𞸶	𞸷		𞸹		𞸻
   		𞹂					𞹇		𞹉		𞹋		𞹍	𞹎	𞹏
   	𞹑	𞹒		𞹔			𞹗		𞹙		𞹛		𞹝		𞹟
   	𞹡	𞹢		𞹤			𞹧	𞹨	𞹩	𞹪		𞹬	𞹭	𞹮	𞹯
   𞹰	𞹱	𞹲		𞹴	𞹵	𞹶	𞹷		𞹹	𞹺	𞹻	𞹼		𞹾
   𞺀	𞺁	𞺂	𞺃	𞺄	𞺅	𞺆	𞺇	𞺈	𞺉		𞺋	𞺌	𞺍	𞺎	𞺏
   𞺐	𞺑	𞺒	𞺓	𞺔	𞺕	𞺖	𞺗	𞺘	𞺙	𞺚	𞺛
   	𞺡	𞺢	𞺣		𞺥	𞺦	𞺧	𞺨	𞺩		𞺫	𞺬	𞺭	𞺮	𞺯
   𞺰	𞺱	𞺲	𞺳	𞺴	𞺵	𞺶	𞺷	𞺸	𞺹	𞺺	𞺻

   𞻰	𞻱	   ؆ ؇ ؈
   """
  ]

const extra_samples = [
   "∂⃖rrule" =>
   """
   # From https://gist.github.com/Keno/d8faa85dd64c878e0985e25942bce450

   # ∂⃖rrule has a 4-recurrence - we model this as 4 separate structs that we
   # cycle between. N.B.: These names match the names that these variables
   # have in Snippet 19 of the terminology guide. They are probably not ideal,
   # but if you rename them here, please update the terminology guide also.

   struct ∂⃖rruleA{N, O}; ∂; ȳ; ȳ̄ ; end
   struct ∂⃖rruleB{N, O}; ᾱ; ȳ̄ ; end
   struct ∂⃖rruleC{N, O}; ȳ̄ ; Δ′′′; β̄ ; end
   struct ∂⃖rruleD{N, O}; γ̄; β̄ ; end

   function (a::∂⃖rruleA{N, O})(Δ) where {N, O}
   @destruct (α, ᾱ) = a.∂(a.ȳ, Δ)
   (α, ∂⃖rruleB{N, O}(ᾱ, a.ȳ̄))
   end

   function (b::∂⃖rruleB{N, O})(Δ′...) where {N, O}
   @destruct ((Δ′′′, β), β̄) = b.ᾱ(Δ′)
   (β, ∂⃖rruleC{N, O}(b.ȳ̄, Δ′′′, β̄))
   end

   function (c::∂⃖rruleC{N, O})(Δ′′) where {N, O}
   @destruct (γ, γ̄) = c.ȳ̄((Δ′′, c.Δ′′′))
   (Base.tail(γ), ∂⃖rruleD{N, O}(γ̄, c.β̄))
   end

   function (d::∂⃖rruleD{N, O})(Δ⁴...) where {N, O}
   (δ₁, δ₂), δ̄  = d.γ̄(Zero(), Δ⁴...)
   (δ₁, ∂⃖rruleA{N, O+1}(d.β̄ , δ₂, δ̄ ))
   end

   # Terminal cases
   function (c::∂⃖rruleB{N, N})(Δ′...) where {N}
   @destruct (Δ′′′, β) = c.ᾱ(Δ′)
   (β, ∂⃖rruleC{N, N}(c.ȳ̄, Δ′′′, nothing))
   end
   (c::∂⃖rruleC{N, N})(Δ′′) where {N} = Base.tail(c.ȳ̄((Δ′′, c.Δ′′′)))
   (::∂⃖rruleD{N, N})(Δ...) where {N} = error("Should not be reached")

   # ∂⃖rrule
   @Base.pure term_depth(N) = 2^(N-2)
   function (::∂⃖rrule{N})(z, z̄) where {N}
   @destruct (y, ȳ) = z
   y, ∂⃖rruleA{term_depth(N), 1}(∂⃖{minus1(N)}(), ȳ, z̄)
   end
   """
  ]

all_samples = [text_samples; extra_samples]

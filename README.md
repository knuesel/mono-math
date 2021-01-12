## Comparison of math symbols in monospace fonts

This repository holds the source files for https://mono-math.netlify.app/ .

The published files are in `public/`. The samples and some other files are generated
with Julia. To recreate them, first install the dependencies by running the
following commands in the directory of this repository:

```
julia --project
]instantiate
```

Edit the font list in `src/fonts.jl`. By default this list refers to font files
in `resources/fonts`. These files are not included in the repository.

Edit the Unicode samples in `src/samples.jl`.

Then in Julia run for example:

```
using MonoMath
MonoMath.make_all()
```

## Comparison of math symbols in monospace fonts.

The site files are in `public/`. The samples and some other files are generated
with Julia. To recreate them, first install the dependencies by running the
following commands in the directory of this repository:

```
julia --project
]instantiate
```

Then run for example:

```
using MonoMath
MonoMath.make_all()
```

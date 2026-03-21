```@copybutton
```

# Usage with Literate.jl

If your documentation pages are generated from Julia scripts via
[Literate.jl](https://github.com/fredrikekre/Literate.jl), you can add the
`@copybutton` block as a comment in your `.jl` source file.

## Basic Usage

In Literate.jl, lines starting with `#` become markdown. To create a fenced
code block like `` ```@copybutton` ``, prefix each line with `# `:

```julia
# ```@copybutton
# ```

# # My Tutorial
#
# This page will have the copy button enabled, serving
# the page's own generated markdown source.

using MyPackage
# ...
```

## Specifying a Source File

You can point to the original `.jl` script so users get the runnable Julia file
instead of the generated markdown:

```julia
# ```@copybutton
# literate/tutorials/my_tutorial.jl
# ```

# # My Tutorial
#
# Users who click "Copy" will get the raw Julia script.

using MyPackage
# ...
```

The path is relative to the doc root directory (the directory containing `make.jl`).

## Complete Example

Here is a full `docs/make.jl` setup with Literate.jl and DocumenterCopyButton:

```julia
using Documenter
using Literate
using DocumenterCopyButton: CopyButton
using MyPackage

# Generate markdown from Literate scripts
Literate.markdown(
    "docs/literate/tutorial.jl",
    "docs/src/generated/";
    execute = true,
)

makedocs(;
    sitename = "MyPackage.jl",
    plugins = [CopyButton()],
    pages = [
        "Home" => "index.md",
        "Tutorial" => "generated/tutorial.md",
    ],
)
```

Then in `docs/literate/tutorial.jl`:

```julia
# ```@copybutton
# literate/tutorial.jl
# ```

# # Tutorial
#
# Welcome to the tutorial!

using MyPackage

x = compute_something()
```

When a user clicks **Copy**, they get the raw `tutorial.jl` file.
When they click **AI**, the provider opens with a URL pointing to the
hosted markdown version.

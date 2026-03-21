# DocumenterCopyButton.jl

A [Documenter.jl](https://documenter.juliadocs.org/) plugin that adds floating **"Copy as Markdown"** and **"Open in AI"** buttons to opted-in documentation pages.

## Quick Start

Add `DocumenterCopyButton` to your docs environment, then pass the plugin to `makedocs`:

```julia
using Documenter
using DocumenterCopyButton

makedocs(;
    plugins = [CopyButton()],
    # ...
)
```

Then add a `@copybutton` block to any page you want to enable:

````markdown
```@copybutton
```
````

The page will show floating buttons in the bottom-right corner:
- **Copy** — copies the page's markdown source to the clipboard
- **AI** — dropdown to open the page in Claude, ChatGPT, Perplexity, and more

## Features

- Works offline and with `file://` URLs — markdown is embedded directly in the HTML
- Bulma-native theming — inherits Documenter's active theme (light, dark, catppuccin, etc.)
- Custom source files — point to a Literate.jl script or any other file
- Configurable AI providers and prompt prefix

## Usage with Literate.jl

In Literate.jl source files, add the block as a comment:

```julia
# ```@copybutton
# literate/tutorials/my_tutorial.jl
# ```

# # My Tutorial
using MyPackage
# ...
```

## Documentation

See the [full documentation](https://harmoniqs.github.io/DocumenterCopyButton.jl/dev/) for details on configuration, custom providers, and more.

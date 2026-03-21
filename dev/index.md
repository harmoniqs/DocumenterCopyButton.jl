```@copybutton
```

# DocumenterCopyButton.jl

A [Documenter.jl](https://documenter.juliadocs.org/) plugin that adds floating
**"Copy as Markdown"** and **"Open in AI"** buttons to opted-in documentation pages.

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

That's it! The page will now show floating buttons in the bottom-right corner.

## How It Works

1. **`@copybutton` block** — A custom Documenter at-block that opts a page in.
   The block content is an optional path to a source file; if empty, it defaults
   to the page's own markdown source.

2. **Post-render pipeline step** — After Documenter renders HTML, the plugin:
   - Copies the source file alongside the HTML output
   - Embeds the markdown content directly in the HTML (for offline/`file://` support)
   - Injects a floating UI with JS/CSS

3. **Client-side JS** — Vanilla JavaScript creates the floating button group:
   - **Copy** — copies the markdown source to the clipboard
   - **AI** — dropdown with configurable AI providers that open the page URL
     in a new tab with a prompt prefix

## Features

- Works with `file://` URLs (no server required) — markdown is embedded in the HTML
- Bulma-native theming — buttons and dropdown inherit Documenter's active theme
- Modal-aware — buttons hide behind Documenter's settings/search overlays
- Supports all Documenter themes (light, dark, catppuccin variants)
- Hidden on mobile (`< 768px`)

## Specifying a Source File

By default, `@copybutton` uses the page's own markdown source. You can specify
a different file (e.g. a Literate.jl script):

````markdown
```@copybutton
literate/tutorials/first_gate.jl
```
````

The path is relative to the doc root directory.

## Custom Providers

Override the default AI providers:

```julia
CopyButton(providers = [
    "Claude" => "https://claude.ai/new?q=",
    "MyAI"   => ("https://myai.com/?q=", "&extra=1"),
])
```

Or disable the AI dropdown entirely:

```julia
CopyButton(providers = [])
```

using Documenter: Plugin

"""
    Provider(name, base_url, suffix)

An AI provider configuration for the "Open in AI" dropdown.

# Fields

- `name::String`: Display name shown in the dropdown (e.g. `"Claude"`)
- `base_url::String`: Base URL for the provider, to which the encoded query is appended
- `suffix::String`: Optional suffix appended after the encoded query (e.g. `"&hints=search"`)
"""
struct Provider
    name::String
    base_url::String
    suffix::String
end

"""
    DEFAULT_PROVIDERS

Default list of AI providers included in the "Open in AI" dropdown:
Claude, ChatGPT, Perplexity, Grok, v0, Cursor, and Zed.
"""
const DEFAULT_PROVIDERS = Provider[
    Provider("ChatGPT",    "https://chatgpt.com/?q=",               "&hints=search"),
    Provider("Claude (beta)", "https://claude.ai/new?q=",           ""),
    Provider("Perplexity", "https://www.perplexity.ai/?q=",         ""),
    Provider("Grok",       "https://x.com/i/grok?text=",            ""),
    Provider("v0",         "https://v0.app/chat?q=",                ""),
    Provider("Cursor",     "https://cursor.com/link/prompt?text=",  ""),
    Provider("Zed",        "zed://agent?prompt=",                   ""),
]

"""
    CopyButton(; providers=nothing, prompt="Read", copy_label="Copy for AI")

A [`Documenter.Plugin`] that adds floating "Copy as Markdown" and "Open in AI"
buttons to opted-in documentation pages.

Pages opt in by including a [`@copybutton`](@ref CopyButtonBlocks) block in their markdown source.

# Keyword Arguments

- `providers`: A list of AI providers for the "Open in AI" dropdown.
  Defaults to [`DEFAULT_PROVIDERS`](@ref). Each element can be:
  - A [`Provider`](@ref) instance
  - A `name => base_url` pair (suffix defaults to `""`)
  - A `name => (base_url, suffix)` pair
  Set to an empty list to disable the "Open in AI" button.
- `prompt`: A prefix string prepended to the URL when opening in an AI provider.
  Defaults to `"Read"`.
- `copy_label`: Label text for the copy button. Defaults to `"Copy for AI"`.

# Example

```julia
using DocumenterCopyButton: CopyButton

makedocs(;
    plugins = [CopyButton()],
    # ...
)
```

Custom providers:

```julia
CopyButton(providers = [
    "Claude" => "https://claude.ai/new?q=",
    "MyAI"   => ("https://myai.com/?q=", "&extra=1"),
])
```
"""
struct CopyButton <: Plugin
    providers::Vector{Provider}
    prompt::String
    copy_label::String

    function CopyButton(;
        providers=nothing,
        prompt="Read",
        copy_label="Copy for AI",
    )
        provs = if providers === nothing
            copy(DEFAULT_PROVIDERS)
        else
            Provider[
                p isa Provider ? p :
                Provider(p.first, p.second isa Tuple ? p.second[1] : p.second,
                         p.second isa Tuple && length(p.second) > 1 ? p.second[2] : "")
                for p in providers
            ]
        end
        new(provs, prompt, copy_label)
    end
end

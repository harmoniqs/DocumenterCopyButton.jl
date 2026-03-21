using Documenter: Plugin

struct Provider
    name::String
    base_url::String
    suffix::String
end

const DEFAULT_PROVIDERS = Provider[
    Provider("Claude",     "https://claude.ai/new?q=",              ""),
    Provider("ChatGPT",    "https://chatgpt.com/?q=",               "&hints=search"),
    Provider("Perplexity", "https://www.perplexity.ai/?q=",         ""),
    Provider("Grok",       "https://x.com/i/grok?text=",            ""),
    Provider("T3",         "https://t3.chat/new?q=",                ""),
    Provider("v0",         "https://v0.app/chat?q=",                ""),
    Provider("Cursor",     "https://cursor.com/link/prompt?text=",  ""),
    Provider("Zed",        "zed://agent?prompt=",                   ""),
]

struct CopyButton <: Plugin
    providers::Vector{Provider}
    prompt::String

    function CopyButton(;
        providers=nothing,
        prompt="Read",
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
        new(provs, prompt)
    end
end

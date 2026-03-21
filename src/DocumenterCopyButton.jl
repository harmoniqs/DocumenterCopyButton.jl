module DocumenterCopyButton

using Documenter: Documenter

export CopyButton, Provider, DEFAULT_PROVIDERS

include("plugin.jl")
include("expander.jl")
include("pipeline.jl")

end

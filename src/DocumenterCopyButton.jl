module DocumenterCopyButton

using Documenter: Documenter

export CopyButton

include("plugin.jl")
include("expander.jl")
include("pipeline.jl")

end

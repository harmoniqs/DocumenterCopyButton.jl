using Test

@testset "DocumenterCopyButton" begin
    include("test_plugin.jl")
    include("test_integration.jl")
end

nothing

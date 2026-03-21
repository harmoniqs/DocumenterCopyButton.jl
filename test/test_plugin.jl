using Test
using DocumenterCopyButton: CopyButton, Provider, DEFAULT_PROVIDERS

@testset "CopyButton defaults" begin
    cb = CopyButton()
    @test length(cb.providers) == length(DEFAULT_PROVIDERS)
    @test cb.prompt == "Read"
end

@testset "CopyButton custom providers" begin
    cb = CopyButton(providers=[
        "MyAI" => ("https://myai.com/?q=", "&extra=1"),
        "Simple" => "https://simple.com/?q=",
    ])
    @test length(cb.providers) == 2
    @test cb.providers[1].name == "MyAI"
    @test cb.providers[1].suffix == "&extra=1"
    @test cb.providers[2].suffix == ""
end

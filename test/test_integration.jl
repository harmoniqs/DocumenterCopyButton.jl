using Test
using DocumenterCopyButton: CopyButton
include("run_makedocs.jl")

@testset "Integration" begin
    cb = CopyButton()

    run_makedocs(
        joinpath(@__DIR__, "test_fixture");
        plugins=[cb],
        pages=["index.md", "tutorial.md"],
        check_success=true,
    ) do dir, result, success, backtrace, output
        @test success

        build = joinpath(dir, "build")

        # tutorial.md companion should exist next to the HTML
        @test isfile(joinpath(build, "tutorial", "tutorial.md"))

        # index.md companion should NOT exist
        @test !isfile(joinpath(build, "index.md"))

        # tutorial/index.html should contain config script
        tutorial_html = read(joinpath(build, "tutorial", "index.html"), String)
        @test occursin("documenter-copybutton-config", tutorial_html)
        @test occursin("copybutton.js", tutorial_html)
        @test occursin("copybutton.css", tutorial_html)

        # index.html should NOT contain config
        index_html = read(joinpath(build, "index.html"), String)
        @test !occursin("documenter-copybutton-config", index_html)

        # Assets should be deployed
        @test isfile(joinpath(build, "assets", "copybutton.js"))
        @test isfile(joinpath(build, "assets", "copybutton.css"))
    end
end

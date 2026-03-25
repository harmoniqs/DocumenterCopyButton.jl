using Documenter
using DocumenterCopyButton

makedocs(;
    sitename="DocumenterCopyButton.jl",
    modules=[DocumenterCopyButton],
    pages=[
        "Home" => "index.md",
        "Literate.jl" => "literate.md",
        "Reference" => "reference.md",
    ],
    format=Documenter.HTML(;
        canonical="https://harmoniqs.github.io/DocumenterCopyButton.jl",
    ),
    plugins=[CopyButton()],
)

deploydocs(;
    repo="github.com/harmoniqs/DocumenterCopyButton.jl",
    versions = ["dev" => "dev", "stable" => "v^", "v#.#"],
    devbranch="main",
)

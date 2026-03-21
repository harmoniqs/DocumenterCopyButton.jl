using Documenter: Expanders
import Documenter: Selectors
using MarkdownAST: MarkdownAST

"""
    @copybutton

A Documenter at-block that opts a page into the copy button feature.

The block content is an optional path to the source file that should be served
to users when they click "Copy as Markdown." The path is relative to the doc
root (e.g. `src/tutorial.md`). If the block is empty, it defaults to the
page's own markdown source.

# Usage

Opt in with the page's own source (most common):

````markdown
```@copybutton
```
````

Opt in with a specific source file (e.g. a Literate.jl script):

````markdown
```@copybutton
literate/tutorials/first_gate.jl
```
````
"""
abstract type CopyButtonBlocks <: Expanders.ExpanderPipeline end

Selectors.order(::Type{CopyButtonBlocks}) = 2.5  # just after MetaBlocks (2.0)

function Selectors.matcher(::Type{CopyButtonBlocks}, node, page, doc)
    return Documenter.iscode(node, r"^@copybutton")
end

function Selectors.runner(::Type{CopyButtonBlocks}, node, page, doc)
    @assert node.element isa MarkdownAST.CodeBlock
    source_path = strip(node.element.code)
    if isempty(source_path)
        @warn "`@copybutton` block has no source path, defaulting to page source" page = page.source
        source_path = page.source
    end
    page.globals.meta[:CopyButton] = source_path
    node.element = Documenter.MetaNode(node.element, copy(page.globals.meta))
end

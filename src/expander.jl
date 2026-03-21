# @copybutton block expander

using Documenter: Expanders
import Documenter: Selectors
using MarkdownAST: MarkdownAST

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

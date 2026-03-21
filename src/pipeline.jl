# CopyButtonPostRender pipeline step

using Documenter.Builder: DocumentPipeline
using Documenter: is_doctest_only
import Documenter: Selectors

abstract type CopyButtonPostRender <: DocumentPipeline end

Selectors.order(::Type{CopyButtonPostRender}) = 7.0

function Selectors.runner(::Type{CopyButtonPostRender}, doc::Documenter.Document)
    is_doctest_only(doc, "CopyButtonPostRender") && return
    @info "CopyButtonPostRender: injecting copy buttons."
    run_copybutton!(doc)
end

function run_copybutton!(doc::Documenter.Document)
    plugin = Documenter.getplugin(doc, CopyButton)
    build_dir = doc.user.build
    assets_dir = joinpath(build_dir, "assets")

    deploy_assets!(assets_dir)

    canonical = _get_canonical(doc)

    for (src, page) in doc.blueprint.pages
        source_path = get(page.globals.meta, :CopyButton, nothing)
        source_path === nothing && continue

        html_path = _html_path(build_dir, src)
        isfile(html_path) || continue

        md_dest = _copy_source!(doc, source_path, html_path)
        md_dest === nothing && continue

        # Compute relative path from the HTML file's directory to build/assets/
        html_dir = dirname(html_path)
        rel_prefix = relpath(assets_dir, html_dir)
        rel_prefix = replace(rel_prefix, '\\' => '/') * "/"

        md_filename = basename(md_dest)

        md_content = read(md_dest, String)
        _inject_html!(html_path, plugin, md_filename, md_content, rel_prefix, canonical, src)
    end
end

function deploy_assets!(assets_dir::String)
    mkpath(assets_dir)
    pkg_assets = joinpath(@__DIR__, "..", "assets")
    for f in ("copybutton.js", "copybutton.css")
        src = joinpath(pkg_assets, f)
        dst = joinpath(assets_dir, f)
        isfile(dst) || cp(src, dst)
    end
end

function _get_canonical(doc::Documenter.Document)
    fmt = doc.user.format
    if fmt isa Documenter.HTML
        url = fmt.canonical
        return url === nothing ? nothing : rstrip(url, '/')
    end
    return nothing
end

function _html_path(build_dir, src)
    base = replace(src, r"\.md$" => "")
    # Pretty URLs: other.md -> other/index.html; flat URLs: other.md -> other.html
    pretty = joinpath(build_dir, base, "index.html")
    flat = joinpath(build_dir, base * ".html")
    isfile(pretty) && return pretty
    return flat
end

function _copy_source!(doc, source_path, html_path)
    # source_path is relative to doc.user.root (e.g. "src/tutorial.md")
    md_src = joinpath(doc.user.root, source_path)
    if !isfile(md_src)
        @warn "CopyButton: source file not found, skipping" path = md_src
        return nothing
    end
    md_dest = joinpath(dirname(html_path), basename(source_path))
    mkpath(dirname(md_dest))
    cp(md_src, md_dest; force=true)
    return md_dest
end

function _inject_html!(html_path, plugin, md_filename, md_content, rel_prefix, canonical, src)
    html = read(html_path, String)

    providers_json = join(
        [
            """{"name":$(json_str(p.name)),"base":$(json_str(p.base_url)),"suffix":$(json_str(p.suffix))}"""
            for p in plugin.providers
        ],
        ",",
    )

    canonical_field =
        canonical === nothing ? "" : ""","canonicalBase":$(json_str(canonical))"""

    md_url = "./" * md_filename

    # Escape the markdown for embedding in a script tag:
    # replace </ with <\/ to prevent premature </script> closing
    escaped_md = replace(md_content, "</" => "<\\/")

    injection = """
    <script id="documenter-copybutton-config" type="application/json">
    {"mdUrl":$(json_str(md_url)),"providers":[$providers_json],"prompt":$(json_str(plugin.prompt)),"copyLabel":$(json_str(plugin.copy_label))$canonical_field,"pagePath":$(json_str(src))}
    </script>
    <script id="documenter-copybutton-content" type="text/plain">$(escaped_md)</script>
    <link rel="stylesheet" href="$(rel_prefix)copybutton.css"/>
    <script src="$(rel_prefix)copybutton.js"></script>
    """

    html = replace(html, "</body>" => injection * "\n</body>")
    write(html_path, html)
end

json_str(s::String) =
    "\"" * replace(replace(s, "\\" => "\\\\"), "\"" => "\\\"") * "\""

# CLAUDE.md

## Overview

`DocumenterCopyButton.jl` is a Documenter.jl plugin that adds floating "Copy as markdown" and "Open in AI" buttons to opted-in documentation pages. Pages opt in via `@meta CopyButton = true`.

## Common Commands

```bash
julia --project=. -e 'using Pkg; Pkg.test()'       # Run test suite
julia --project=docs docs/make.jl                    # Build docs
```

## Architecture

- `src/plugin.jl` — `CopyButton <: Documenter.Plugin` struct and defaults
- `src/pipeline.jl` — `CopyButtonPostRender` pipeline step (order 7.0)
- `assets/` — Vanilla JS/CSS for floating UI, clipboard copy, AI provider dropdown

## Guidelines

* Use explicit imports only — no unused imports.
* Never commit changes or ask to commit. Commits are created manually.

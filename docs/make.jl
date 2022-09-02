using SurfaceCoverage
using Documenter

DocMeta.setdocmeta!(SurfaceCoverage, :DocTestSetup, :(using SurfaceCoverage); recursive=true)

makedocs(;
    modules=[SurfaceCoverage],
    authors="Vinod Janardhanan",
    repo="https://github.com/vinodjanardhanan/SurfaceCoverage.jl/blob/{commit}{path}#{line}",
    sitename="SurfaceCoverage.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://vinodjanardhanan.github.io/SurfaceCoverage.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vinodjanardhanan/SurfaceCoverage.jl",
    devbranch="main",
)

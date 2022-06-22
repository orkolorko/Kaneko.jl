using Kaneko
using Documenter

DocMeta.setdocmeta!(Kaneko, :DocTestSetup, :(using Kaneko); recursive=true)

makedocs(;
    modules=[Kaneko],
    authors="Isaia Nisoli nisoli@im.ufrj.br and contributors",
    repo="https://github.com/orkolorko/Kaneko.jl/blob/{commit}{path}#{line}",
    sitename="Kaneko.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://orkolorko.github.io/Kaneko.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/orkolorko/Kaneko.jl",
    devbranch="main",
)

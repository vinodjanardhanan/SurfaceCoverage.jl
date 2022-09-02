using SurfaceCoverage
using Test

@testset "SurfaceCoverage.jl" begin
    if Sys.islinux() || Sys.isapple()
        lib_dir = "lib/"
    elseif Sys.iswindows()
        lib_dir = "lib\\"
    end
    input_file = "coverage.xml"

    retcode = coverage(input_file, lib_dir)
    @test retcode == Symbol("Success")

end

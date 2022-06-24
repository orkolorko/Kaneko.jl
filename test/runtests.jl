using Kaneko
using Test

@testset "Kaneko.jl" begin
    @test T(4, 0.5) ==1

    a_var = 0:0.1:4

    for a in a_var
        @test T(a, 0.5) == a/4
    end

    x0 = ones(1024)
    for a in a_var
        x=T.(a, x0)
        for i in 1:10
            x = T.(a, x)
        end
        @test x == zeros(1024)
    end

    @test f(2, 1) == -1
    @test f(2, -1) == -1    

end

using PyJuliaTester
using Test

@testset "Compare test/Project.toml and test/environments/main/Project.toml" begin
    @test Text(read(joinpath(@__DIR__, "Project.toml"), String)) ==
          Text(read(joinpath(@__DIR__, "environments", "main", "Project.toml"), String))
end

@testset "PyJuliaTester.runtests" begin
    PyJuliaTester.runtests()
end

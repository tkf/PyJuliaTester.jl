module PyJuliaTester

import Python_jll
using PyVenvs: @pyvenv, PyVenvs

@pyvenv TEST_VENV requirements="julia[test] @ https://github.com/tkf/pyjulia/archive/pyjuliatester.zip"

function test_cmd(args = ``; rebuild::Union{Bool,Nothing} = nothing)
    py = PyVenvs.python(TEST_VENV)
    jl = Base.julia_cmd().exec[1]
    cmd = `$py -m julia.runtests $args`
    env = copy(ENV)
    # Using `PYJULIA_TEST_RUNTIME` instead of `--julia-runtime=$jl` as
    # `with_rebuilt` ignores `--julia-runtime` ATM.
    env["PYJULIA_TEST_RUNTIME"] = jl
    env["JULIA_PROJECT"] = Base.active_project()
    if rebuild !== nothing
        # https://pyjulia.readthedocs.io/en/latest/testing.html
        env["PYJULIA_TEST_REBUILD"] = rebuild ? "yes" : "no"
    end
    cmd = setenv(cmd, env)
    return cmd
end

"""
    PyJuliaTester.runtests([command_args::Cmd]; rebuild::Bool::Bool)

Run `python -m julia.runtests \$command_args`.

If `rebuild == true` (`false`), set `PYJULIA_TEST_REBUILD=yes` (`no`).
See PyJulia's documentation for the effect.

See also:
* [`PyJuliaTester.help`](@ref)
* https://pyjulia.readthedocs.io/en/latest/testing.html
"""
function runtests(args = ``; kwargs...)
    Python_jll.python() do python
        PyVenvs.init(TEST_VENV; python = python)
        cmd = test_cmd(args; kwargs...)
        cmd_print = `$(cmd.exec)`
        @info "Run: $cmd_print"
        run(cmd)
    end
end

"""
    PyJuliaTester.help()

Show help message for PyJulia's `julia.runtests` API.
"""
function help()
    runtests(`--help`)
    return
end

end

# PyJuliaTester

Julia interface for running
[PyJulia's test suite](https://pyjulia.readthedocs.io/en/latest/testing.html)

## Usage

```julia
using Pkg
Pkg.add("PyJuliaTester")
ENV["PYJULIA_TEST_REBUILD"] = "yes"  # somewhat dangerous
ENV["CI"] = "yes"  # optional
Pkg.test("PyJuliaTester")
```

Setting `PYJULIA_TEST_REBUILD` is optional and somewhat dangerous. See
PyJulia's documentation.

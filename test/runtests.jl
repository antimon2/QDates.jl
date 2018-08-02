using Compat
using Compat.Dates
using QDates
using Compat.Test

@static if VERSION < v"0.7.0-DEV.3977"
    Base.repeat(a::AbstractVector, n::Int) = repmat(a, n)
end

tests = ["types", "accessors", "query", "arithmetic", "conversions", "ranges", "adjusters", "rounding"]

for test in tests
    println("start testing: $test.jl")
    @time include("$test.jl")
end
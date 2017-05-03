using QDates
using Base.Test

tests = ["types", "accessors", "query"]

for test in tests
    println("start testing: $test.jl")
    @time include("$test.jl")
end
using QDates
using Base.Test

tests = ["types", "accessors"]

for test in tests
    println("start testing: $test")
    @time include("$(test).jl")
end
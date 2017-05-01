using QDates
using Base.Test

tests = ["qdates", "types"]

for test in tests
    include("$(test).jl")
end
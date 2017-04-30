using QDates
using Base.Test

tests = ["qdates"]

for test in tests
    include("$(test).jl")
end
module App

# include(joinpath(dirname(@__FILE__), "..", "QDates.jl"))
# using .QDates

using ..QDates

function main()
    # @show ARGS
    # @show Base.PROGRAM_FILE
    # if isempty(ARGS)
        qdt = QDates.today()
        println("今日は$(qdt)、$(QDates.dayname(qdt))です。")
    # end
    return
end

end # module

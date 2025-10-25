module CLI

using ..QDates
using Dates

function @main(ARGS)
    isempty(ARGS) && return (qdt = QDates.today(); println("今日は $(qdt)、$(QDates.dayname(qdt)) です。"); 0)

    dic = Dict{String, Int}(
        "今日" => 0,
        "昨日" => -1,
        "明日" => 1,
        "一昨日" => -2,
        "明後日" => 2,
        "一昨昨日" => -3,
        "一昨々日" => -3,
        "明明後日" => 3,
        "明々後日" => 3,
        "弥明後日" => 4,
        "五明後日" => 5,
    )

    return_value = 0
    for arg in ARGS
        try
            qdt = if occursin(r"^\d+-\d+-\d+$", arg)
                QDate(Date(arg, Dates.dateformat"yyyy-mm-dd"))
            elseif occursin(r"^\d+/\d+/\d+$", arg)
                QDate(Date(arg, Dates.dateformat"yyyy/mm/dd"))
            elseif haskey(dic, arg)
                QDates.today() + QDates.Day(dic[arg])
            elseif (m = match(r"(\d+)日(前|後)", arg)) !== nothing
                n = parse(Int, m[1])
                _today = QDates.today()
                m[2] == "前" ? _today - QDates.Day(n) : _today + QDates.Day(n)
            else
                error(lazy"$(arg): 対応していない日付の指定です。")
            end
            println("$arg は、$(qdt)、$(QDates.dayname(qdt)) です。")
        catch e
            showerror(stderr, e)
            println(stderr)
            return_value = 1
        end
    end
    return return_value
end

end
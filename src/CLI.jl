module CLI

using ..QDates
using Dates

printqdate(qdt::QDate) = printqdate(Core.stdout, qdt)
function printqdate(io::IO, qdt::QDate)
    y, m, l, d = yearmonthleapday(qdt)
    # yy = lpad(y, 4, "0")
    # mm = lpad(m, 2, "0")
    # dd = lpad(d, 2, "0")
    # return l ? "旧$(yy)年閏$(mm)月$(dd)日" : "旧$(yy)年$(mm)月$(dd)日"
    Core.print(io, '旧')
    y < 1000 && Core.print(io, '0')
    y < 100 && Core.print(io, '0')
    y < 10 && Core.print(io, '0')
    Core.print(io, y, '年')
    l && Core.print(io, '閏')
    m < 10 && Core.print(io, '0')
    Core.print(io, m, '月')
    d < 10 && Core.print(io, '0')
    Core.print(io, d, '日')
end

function _showerror(io::IO, e::Union{ErrorException, ArgumentError})
    e isa ArgumentError && Core.print(io, "ArgumentError: ")
    Core.print(io, e.msg)
end

function @main(ARGS)
    isempty(ARGS) && begin
        qdt = QDates.today()
        # println("今日は $(qdt)、$(QDates.dayname(qdt)) です。")
        Core.print("今日は ")
        printqdate(Core.stdout, qdt)
        Core.print("、")
        Core.print(QDates.dayname(qdt))
        Core.print(" です。\n")
        return 0
    end
 
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
                # QDate(Date(arg, dateformat"y-m-d"))
                year, month, day = parse.(Int, split(arg, '-'))
                QDate(Date(year, month, day))
            elseif occursin(r"^\d+/\d+/\d+$", arg)
                # QDate(Date(arg, dateformat"yyyy/mm/dd"))
                year, month, day = parse.(Int, split(arg, '/'))
                QDate(Date(year, month, day))
            elseif haskey(dic, arg)
                QDates.today() + QDates.Day(dic[arg])
            elseif (m = match(r"(\d+)日(前|後)", arg)) !== nothing
                n = parse(Int, m[1])
                _today = QDates.today()
                m[2] == "前" ? _today - QDates.Day(n) : _today + QDates.Day(n)
            else
                # error(lazy"$(arg): 対応していない日付の指定です。")
                error("$(arg): 対応していない日付の指定です。")
            end
            # Core.println("$arg は、$(qdt)、$(QDates.dayname(qdt)) です。")
            Core.print(Core.stdout, arg, " は、")
            printqdate(Core.stdout, qdt)
            Core.print("、")
            Core.print(QDates.dayname(qdt))
            Core.println(" です。")
        catch e
            if e isa ErrorException || e isa ArgumentError
                # Base.showerror(Core.stderr, e)
                _showerror(Core.stderr, e)
            else
                # それ以外のエラー
                # Core.println(Core.stderr, lazy"予期せぬエラーが発生しました（$(typeof(e))）。")
                Core.println(Core.stderr, "予期せぬエラーが発生しました（$(typeof(e))）。")
            end
            Core.println(Core.stderr)
            return_value = 1
        end
    end
    return return_value
end

end
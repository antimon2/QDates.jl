module QDates

# # Load dependencies
# deps = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
# if isfile(deps)
#     include(deps)
# else
#     error("QDates not properly installed. Please run Pkg.build(\"QDates\")")
# end

# @assert @isdefined libqref
include(joinpath(dirname(@__FILE__), "qref", "QREF.jl"))

# libqref.qref
function _qref(jdn::Union{Int32, UInt32})
    # cqdate = Array{Cint}(undef, 7)
    # ccall((:qref, libqref), Nothing, (Cint, Ref{Cint}), jdn, cqdate)
    # cqdate
    qdinfo = QREF.qref(jdn)
    Cint[qdinfo.j, qdinfo.y, 0, qdinfo.m, qdinfo.md, mod(qdinfo.m + qdinfo.md - 2, 6), qdinfo.leap]
end
_qref(jdn::Signed) = _qref(jdn % Int32)
_qref(jdn::Unsigned) = _qref(jdn % UInt32)

# libqref.rqref
function _rqref(cqdate::Array{Cint,1})
    # Int(ccall((:rqref, libqref), Cint, (Ref{Cint},), cqdate))
    QREF.rqref(QREF.QDInfo(0, 0, cqdate[2], cqdate[4], Bool(cqdate[7]), cqdate[5]))
end

import Dates
import Dates:
    year,
    month,
    day,
    dayofweek,
    yearmonth,
    monthday,
    yearmonthday,
    days

const DAYS_OFFSET = 1721425
# const FIRST_VALUE = 162193
# const LAST_VALUE = 803567
const FIRST_VALUE = QREF.FIRST_JULIAN - DAYS_OFFSET
const LAST_VALUE = QREF.LAST_JULIAN - DAYS_OFFSET
# const FIRST_YEAR = 445
# const LAST_YEAR = 2200
const FIRST_YEAR = QREF.FIRST_YEAR
const LAST_YEAR = QREF.LAST_YEAR

include("types.jl")
include("periods.jl")
include("accessors.jl")
include("query.jl")
include("arithmetic.jl")
include("conversions.jl")
include("ranges.jl")
include("adjusters.jl")
include("rounding.jl")
include("io.jl")

function _rqref_strict(year::Integer, month::Integer=1, leap::Bool=false, day::Integer=1)
    qarr0 = Cint[FIRST_VALUE+DAYS_OFFSET,year,0,month,day,0,leap]
    jdn = _rqref(qarr0)
    qarr1 = _qref(jdn)
    if qarr1[[2,4,5,7]] != qarr0[[2,4,5,7]]
        throw(ArgumentError(_chk_error(qarr0, qarr1)))
    end
    jdn
end

function _chk_error(qarr0::Array{Cint,1}, qarr1::Array{Cint,1})
    if !(FIRST_YEAR <= qarr0[2] <= LAST_YEAR)
        "Year: $(qarr0[2]) out of range ($FIRST_YEAR:$LAST_YEAR)"
    elseif !(1 <= qarr0[4] <= 12)
        "Month: $(qarr0[4]) out of range (1:12)"
    elseif qarr0[7] != 0 && qarr1[2] == 0
        "Month: $(qarr0[2])/$(qarr0[4]) not a leap month"
    elseif qarr0[5] < 1
        "Day: $(qarr0[5]) out of range (1:$(daysinmonth(qarr0[2],qarr0[4],(qarr0[7]!=0))))"
    elseif qarr0[2] == LAST_YEAR && qarr0[4] == 12 && qarr0[5] > 1
        # 2100/12 is privilleged
        "Day: $(qarr0[5]) out of range (1:1)"
    elseif qarr0[5] > qarr1[5]
        "Day: $(qarr0[5]) out of range (1:$(qarr0[5]-qarr1[5]))"
    else
        "$(qarr0)/$(qarr1)"
    end
end

export
    QDate,
    year,
    month,
    day,
    dayofweek,
    yearmonth,
    monthday,
    yearmonthday,
    days,
    firstdayofyear,
    lastdayofyear,
    firstdayofmonth,
    lastdayofmonth,
    today,
    isleapmonth,
    yearmonthleap,
    monthleapday,
    yearmonthleapday

end # module
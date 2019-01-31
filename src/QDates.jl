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
    # QREF.rqref(QREF.QDInfo(0, 0, cqdate[2], cqdate[4], Bool(cqdate[7]), cqdate[5]))
    QREF.rqref(cqdate[2], cqdate[4], Bool(cqdate[7]), cqdate[5]).j
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
    # qarr0 = Cint[FIRST_VALUE+DAYS_OFFSET,year,0,month,day,0,leap]
    # jdn = _rqref(qarr0)
    # qarr1 = _qref(jdn)
    # if qarr1[[2,4,5,7]] != qarr0[[2,4,5,7]]
    #     throw(ArgumentError(_chk_error(qarr0, qarr1)))
    # end
    # jdn
    qdinfo = QREF.rqref(year, month, leap, day)
    if year != qdinfo.y || month != qdinfo.m || leap != qdinfo.leap || day != qdinfo.md
        throw(ArgumentError(_chk_error(year, month, leap, day, qdinfo)))
    end
    qdinfo.j
end

function _chk_error(y::Integer, m::Integer, leap::Bool, md::Integer, qdinfo::QREF.QDInfo)
    if !(FIRST_YEAR <= y <= LAST_YEAR)
        "Year: $y out of range ($FIRST_YEAR:$LAST_YEAR)"
    elseif !(1 <= m <= 12)
        "Month: $m out of range (1:12)"
    elseif leap && !qdinfo.leap
        "Month: $(y)/$(m) not a leap month"
    elseif md < 1
        "Day: $md out of range (1:$(daysinmonth(y, m, leap)))"
    # elseif y == LAST_YEAR && m == 12 && md > 1
    #     # 2100/12 is privilleged
    #     "Day: $(md) out of range (1:1)"
    elseif md > qdinfo.md
        "Day: $(md) out of range (1:$(md-qdinfo.md))"
    else
        "($y, $m, $leap, $md)/($(qdinfo.y), $(qdinfo.m), $(qdinfo.leap), $(qdinfo.md))"
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
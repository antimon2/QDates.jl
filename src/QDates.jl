module QDates

using Compat

# Load dependencies
deps = joinpath(dirname(@__FILE__), "..", "deps", "deps.jl")
if isfile(deps)
    include(deps)
else
    error("QDates not properly installed. Please run Pkg.build(\"QDates\")")
end

@assert isdefined(:libqref)

# libqref.qref
function _qref(jdn)
    cqdate = Array{Cint}(7)
    ccall((:qref, libqref), Void, (Cint, Ref{Cint}), jdn, cqdate)
    cqdate
end

# libqref.rqref
function _rqref(cqdate::Array{Cint,1})
    convert(Int, ccall((:rqref, libqref), Cint, (Ref{Cint},), cqdate))
end

import Base.Dates:
    Date,
    TimeType,
    UTD,
    UTInstant,
    Day,
    year,
    month,
    day,
    week,
    days,
    yearmonth,
    monthday,
    yearmonthday,
    value

const FIRST_VALUE = 162193
const LAST_VALUE = 767009
const FIRST_YEAR = 445
const LAST_YEAR = 2100
const DAYS_OFFSET = 1721425

immutable QDate <: TimeType
    instant::UTInstant{Day}
    QDate(instant::UTInstant{Day}) = new(instant)
end
@inline QDate(year::Int, month::Int=1, day::Int=1) = QDate(year, month, false, day)
function QDate(year::Int, month::Int, leap::Bool, day::Int)
    jdn = _rqref(year, month, leap, day)
    QDate(UTD(jdn - DAYS_OFFSET))
end

@inline function _qref(qdt::Union{Date,QDate})
    _qref(date2jdn(qdt))
end
@inline function _rqref(year::Integer, month::Integer=1, leap::Bool=false, day::Integer=1)
    _rqref(Cint[FIRST_VALUE+DAYS_OFFSET,year,0,month,day,0,leap])
end

function _check_value(value::Int)
    if !(FIRST_VALUE <= value <= LAST_VALUE)
        throw(DomainError())
    end
end
@inline _check_value(instant::UTInstant{Day}) = _check_value(instant.periods.value)

@inline date2jdn(dt::Union{Date,QDate}) = value(dt) + DAYS_OFFSET

function year(qdt::QDate)
    cqdate = _qref(qdt)
    convert(Int, cqdate[2])
end

function month(qdt::QDate)
    cqdate = _qref(qdt)
    convert(Int, cqdate[4])
end

function day(qdt::QDate)
    cqdate = _qref(qdt)
    convert(Int, cqdate[5])
end

function week(qdt::QDate)
    cqdate = _qref(qdt)
    convert(Int, cqdate[6])
end

function yearmonth(qdt::QDate)
    cqdate = _qref(qdt)
    (convert(Int, cqdate[2]), convert(Int, cqdate[4]))
end

function monthday(qdt::QDate)
    cqdate = _qref(qdt)
    (convert(Int, cqdate[4]), convert(Int, cqdate[5]))
end

function yearmonthday(qdt::QDate)
    cqdate = _qref(qdt)
    (convert(Int, cqdate[2]), convert(Int, cqdate[4]), convert(Int, cqdate[5]))
end

function isleapmonth(qdt::QDate)
    cqdate = _qref(qdt)
    cqdate[7] != 0
end

function yearmonthleapday(qdt::QDate)
    cqdate = _qref(qdt)
    (convert(Int, cqdate[2]), convert(Int, cqdate[4]), cqdate[7] != 0, convert(Int, cqdate[5]))
end

@inline days(qdt::QDate) = value(qdt)

Base.convert(::Type{Date}, qdt::QDate) = Date(qdt.instant)
Base.convert(::Type{QDate}, dt::Date) = QDate(dt.instant)
Base.convert(::Type{DateTime}, qdt::QDate) = DateTime(UTM(value(qdt)*86400000))
Base.convert(::Type{QDate}, dt::DateTime) = QDate(UTD(days(dt)))

export
    QDate,
    year,
    month,
    day,
    week,
    yearmonth,
    monthday,
    yearmonthday,
    days,
    isleapmonth,
    yearmonthleapday

end # module
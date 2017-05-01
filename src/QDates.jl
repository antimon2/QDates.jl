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
    Int(ccall((:rqref, libqref), Cint, (Ref{Cint},), cqdate))
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
@inline QDate(year::Integer, month::Integer=1, day::Integer=1) = QDate(year, month, false, day)
function QDate(year::Integer, month::Integer, leap::Bool, day::Integer)
    # jdn = _rqref(year, month, leap, day)
    jdn = _rqref_strict(year, month, leap, day)
    QDate(UTD(jdn - DAYS_OFFSET))
end
@inline _ci(x) = convert(Cint, x)
@inline QDate(y,m=1,d=1) = QDate(_ci(y), _ci(m), _ci(d))
@inline QDate(y,m,l::Bool,d) = QDate(_ci(y), _ci(m), l, _ci(d))
@inline QDate(qdt::QDate) = qdt

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
    elseif qarr0[5] > qarr1[5]
        "Day: $(qarr0[5]) out of range (1:$(qarr0[5]-qarr1[5]))"
    else
        "$(qarr0)/$(qarr1)"
    end
end

@inline date2jdn(dt::Union{Date,QDate}) = value(dt) + DAYS_OFFSET

function year(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[2])
end

function month(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[4])
end

function day(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[5])
end

function week(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[6]) + 1
end

function yearmonth(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]))
end

function monthday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[4]), Int(cqdate[5]))
end

function yearmonthday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]), Int(cqdate[5]))
end

function isleapmonth(qdt::QDate)
    cqdate = _qref(qdt)
    cqdate[7] != 0
end

function yearmonthleapday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]), cqdate[7] != 0, Int(cqdate[5]))
end

@inline days(qdt::QDate) = value(qdt)

function daysinmonth(y::Integer, m::Integer, leap::Bool=false)
    y1 = y
    m1 = m + 1
    if m1 > 12
        y1 += 1
        m1 = 1
    end
    jdn0 = _rqref(y, m, leap)
    if jdn0 == 0
        0
    elseif leap
        _rqref(y1, m1, false) - jdn0
    else
        jdn1 = _rqref(y, m, true)
        (jdn1 > 0 ? jdn1 : _rqref(y1, m1, false)) - jdn0
    end
end

Base.convert(::Type{Date}, qdt::QDate) = Date(qdt.instant)
Base.convert(::Type{QDate}, dt::Date) = QDate(dt.instant)
Base.convert(::Type{DateTime}, qdt::QDate) = DateTime(UTM(value(qdt)*86400000))
Base.convert(::Type{QDate}, dt::DateTime) = QDate(UTD(days(dt)))

@inline Date(qdt::QDate) = convert(Date, qdt)
@inline QDate(dt::Date) = convert(QDate, dt)
@inline DateTime(qdt::QDate) = convert(DateTime, qdt)
@inline QDate(dt::DateTime) = convert(QDate, dt)

today() = QDate(Dates.now())
@inline today(::Type{QDate}) = today()
today(::Type{Date}) = Dates.today()
Base.Dates.today(::Type{QDate}) = today()
@inline Base.Dates.today(::Type{Date}) = Dates.today()

Base.isless(x::QDate, y::QDate) = isless(value(x), value(y))

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
    daysinmonth,
    today,
    isleapmonth,
    yearmonthleapday

end # module
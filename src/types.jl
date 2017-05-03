# types.jl

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

@inline QDate(y::Year, m::Month=Month(1), d::Day=Day(1)) = QDate(value(y), value(m), false, value(d))
@inline QDate(y::Year, m::Month, l::Bool, d::Day=Day(1)) = QDate(value(y), value(m), l, value(d))

function QDate(periods::Union{Dates.Period,Bool}...)
    y = Nullable{Year}(); m = Month(1); l = false; d = Day(1)
    for p in periods
        isa(p, Year) && (y = Nullable{Year}(p))
        isa(p, Month) && (m = p::Month)
        isa(p, Bool) && (l = p::Bool)
        isa(p, Day) && (d = p::Day)
    end
    if isnull(y)
        throw(ArgumentError("Dates.Year must be specified"))
    end
    return QDate(get(y),m,l,d)
end

Base.eps(::QDate) = Day(1)

Base.typemax(::Union{QDate,Type{QDate}}) = QDate(2100, 12, 1)
Base.typemin(::Union{QDate,Type{QDate}}) = QDate(445, 1, 1)


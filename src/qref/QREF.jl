# original (inspired by): 
#   qref.c: Copyright (C) 1991-1995,1997,1998,2000,2001 Tadayoshi Funaba All rights reserved
#   $Id: qref.c,v 1.7 2001-02-06 23:35:44+09 tadf Exp $

module QREF

abstract type QDStatus end
struct QDOK <: QDStatus end
struct QDRecordError <: QDStatus end
struct QDJulianError <: QDStatus end
struct QDYearError <: QDStatus end
struct QDMonthError <: QDStatus end
struct QDLeapMonthError <: QDStatus end
struct QDDayError <: QDStatus end

struct QDInfo{ST<:QDStatus, I<:Integer, J<:Integer, Y<:Integer, M<:Integer, D<:Integer}
    idx::I
    j::J
    y::Y
    m::M
    leap::Bool
    md::D
end
(::Type{QDInfo{S}})(idx::I, j::J, y::Y, m::M, leap::Bool, md::D) where {S, I, J, Y, M, D} = 
    QDInfo{S, I, J, Y, M, D}(idx, j, y, m, leap, md)
(::Type{QDInfo{QDRecordError}})(idx::Integer) = QDInfo{QDRecordError}(idx, 0, 0, 0, false, 0)
(::Type{QDInfo{QDJulianError}})(j::Integer) = QDInfo{QDJulianError}(0, j, 0, 0, false, 0)
(::Type{QDInfo{QDYearError}})(y::Integer) = QDInfo{QDYearError}(0, 0, y, 0, false, 0)
(::Type{QDInfo{QDMonthError}})(m::Integer) = QDInfo{QDMonthError}(0, 0, 0, m, false, 0)
(::Type{QDInfo{QDLeapMonthError}})(y::Integer, m::Integer) = QDInfo{QDLeapMonthError}(0, 0, y, m, true, 0)
(::Type{QDInfo{QDDayError}})(idx::Integer, md::Integer) = QDInfo{QDDayError}(idx, 0, 0, 0, false, md)

struct CQDate
    j::Int32
    y::Int16
    m::Int8
    leap::Bool
end

const qt = let qtsrcpath = joinpath(dirname(@__FILE__), "QTSRC.bin")
    _dims = filesize(qtsrcpath) + 1
    _qt = Vector{CQDate}(undef, _dims)
    open(qtsrcpath, "r") do f_in
        j = 0
        m = 1
        y = -1
        idx = 1
        while !eof(f_in)
            qts = read(f_in, UInt8)
            ny = isodd(qts >> 1)
            l = isodd(qts)
            l || (m = ny ? 1 : m + 1)
            ny && (y += 1)
            _qt[idx] = CQDate(j, y, m, l)
            j += qts >> 2
            idx += 1
        end
        _qt[idx] = CQDate(j, y + 1, 1, false)
    end
    _qt
end

const FIRST_RECORD = 1
const LAST_RECORD = length(qt) - 1

const FIRST_JULIAN = 1883618  # 旧0445年01月01日
const LAST_JULIAN = FIRST_JULIAN + qt[end].j - qt[1].j - 1
# LAST_JULIAN == 2524992  # 旧2200年12月29日

const FIRST_YEAR = 445
const LAST_YEAR = FIRST_YEAR + qt[LAST_RECORD].y
# LAST_YEAR == 2200

function qi(j::Int)
    l = FIRST_RECORD
    u = LAST_RECORD
    while l < u
        m = Int(Int64(j - qt[l].j) * (u - l) ÷ (qt[u].j - qt[l].j)) + l
        if qt[m].j < j
            l = m + 1
            qt[l].j > j && return l - 1
        elseif qt[m].j > j
            u = m - 1
            qt[u].j < j && return u
        else
            return m
        end
    end
    # NOTREACHED
    return -1
end

function qref(j::Int)
    if j < FIRST_JULIAN || j > LAST_JULIAN
        # Note: Not to be thrown `ArgumentError` here.
        return QDInfo{QDJulianError}(j)
    end
    idx = qi(j - FIRST_JULIAN)
    p = qt[idx]
    m = Int(p.m)
    y = p.y + FIRST_YEAR
    md = 1 + j - (p.j + FIRST_JULIAN)
    leap = p.leap
    return QDInfo{QDOK}(idx, j, y, m, leap, md)
end
qref(j::Integer) = qref(Int(j))

function nextmonth(qdinfo::QDInfo)
    idx = qdinfo.idx + 1
    p = qt[idx]
    j = p.j + FIRST_JULIAN
    m = Int(p.m)
    y = p.y + FIRST_YEAR
    leap = p.leap
    return QDInfo{QDOK}(idx, j, y, m, leap, 1)
    # Note: returns QDInfo of 1st day of next month
end

function addmonth(qdinfo::QDInfo, month::Integer)
    idx = qdinfo.idx + month
    if !(FIRST_RECORD ≤ idx ≤ LAST_RECORD)
        # Note: Not to be thrown `ArgumentError` here.
        return QDInfo{QDRecordError}(idx)
    end
    p = qt[idx]
    j = p.j + FIRST_JULIAN
    m = Int(p.m)
    y = p.y + FIRST_YEAR
    leap = p.leap
    return QDInfo{QDOK}(idx, j, y, m, leap, 1)
    # Note: returns QDInfo of 1st day of the month
end

function nextyear(qdinfo::QDInfo)
    idx = qdinfo.idx + 12 - qdinfo.m
    p = qt[idx]
    if p.y + FIRST_YEAR == qdinfo.y
        idx += 1
        p = qt[idx]
    end
    j = p.j + FIRST_JULIAN
    y = p.y + FIRST_YEAR
    return QDInfo{QDOK}(idx, j, y, 1, false, 1)
    # Note: returns QDInfo of 1st day of next year
end

function rqi2(y::Int)
    l = FIRST_RECORD
    u = LAST_RECORD
    while l < u
        m = (y - qt[l].y) * (u - l) ÷ (qt[u].y - qt[l].y) + l
    	if qt[m].y < y
    	    l = m + 1
            qt[l].y > y && return l - 1
        elseif qt[m].y > y
    	    u = m - 1
    	    qt[u].y < y && return u
        else
            return m
        end
    end
    # NOTREACHED
    return -1
end

function _firstidxofyear(idx)
    o = qt[idx]
    if o.m > 1 || o.leap
        idx -= o.m - 1 + o.leap
        o = qt[idx]
        while o.m > 1 || o.leap
            idx -= 1
            o = qt[idx]
        end
    end
    idx
end

function rqi(y::Int)
    _firstidxofyear(rqi2(y))
end
rqi(y::Integer) = rqi(Int(y))

function rqref(y::Integer, month::Integer=1, leap::Bool=false, day::Integer=1)
    if !(FIRST_YEAR ≤ y ≤ LAST_YEAR)
        # Note: Not to be thrown `ArgumentError` here.
        return QDInfo{QDYearError}(y)
    end
    if !(1 ≤ month ≤ 12)
        # Note: Not to be thrown `ArgumentError` here.
        return QDInfo{QDMonthError}(month)
    end

    idx = rqi(y - FIRST_YEAR)
    if month > 1 || leap
        idx += month - 1 + leap
        if leap && !qt[idx].leap
            # Note: Not to be thrown `ArgumentError` here.
            return QDInfo{QDLeapMonthError}(y, month)
        end
        while !(qt[idx].m == month && qt[idx].leap == leap)
            idx += 1
        end
    end
    j = day - 1 + qt[idx].j + FIRST_JULIAN
    if !(qt[idx].j ≤ j - FIRST_JULIAN < qt[idx + 1].j)
        # Note: Not to be thrown `ArgumentError` here.
        return qref(j)
    end
    return QDInfo{QDOK}(idx, j, Int(y), Int(month), leap, Int(day))
end
function rqref_strict(y::Integer, month::Integer=1, leap::Bool=false, day::Integer=1)
    qdinfo = _check_qdinfo(rqref(y, month, leap, day))
    if qdinfo.md != day
        qdinfo1 = rqref(y, month, leap, 1)
        _check_qdinfo(QDInfo{QDDayError}(qdinfo1.idx, day))
    end
    qdinfo
end
_check_qdinfo(qdinfo::QDInfo{QDOK}) = qdinfo
function _check_qdinfo(qderror::QDInfo{QDRecordError})
    throw(ArgumentError("Idx: $(qderror.idx) out of range ($FIRST_RECORD:$LAST_RECORD)"))
end
function _check_qdinfo(qderror::QDInfo{QDJulianError})
    throw(ArgumentError("Jdn: $(qderror.j) out of range ($FIRST_JULIAN:$LAST_JULIAN)"))
end
function _check_qdinfo(qderror::QDInfo{QDYearError})
    throw(ArgumentError("Year: $(qderror.y) out of range ($FIRST_YEAR:$LAST_YEAR)"))
end
function _check_qdinfo(qderror::QDInfo{QDMonthError})
    throw(ArgumentError("Month: $(qderror.m) out of range (1:12)"))
end
function _check_qdinfo(qderror::QDInfo{QDLeapMonthError})
    throw(ArgumentError("Month: $(qderror.y)/$(qderror.m) not a leap month"))
end
function _check_qdinfo(qderror::QDInfo{QDDayError})
    _daysinmonth = qt[qderror.idx + 1].j - qt[qderror.idx].j
    throw(ArgumentError("Day: $(qderror.md) out of range (1:$(_daysinmonth))"))
end

function dayofyear(q::QDInfo)
    idx = _firstidxofyear(q.idx)
    return 1 + q.j - (qt[idx].j + FIRST_JULIAN)
end

function lastjdninyear(q::QDInfo)
    idx = q.idx
    y = qt[idx].y
    while qt[idx].y == y
        idx += 1
    end
    qt[idx].j - 1 + FIRST_JULIAN
end

function daysinmonth(q::QDInfo{QDOK})
    qt[q.idx + 1].j - qt[q.idx].j
end
daysinmonth(q::QDInfo) = 0

function daysinyear(q::QDInfo)
    sidx = _firstidxofyear(q.idx)
    sqt = qt[sidx]
    eidx = sidx + 12
    eqt = qt[eidx]
    eqt.y == sqt.y && (eqt = qt[eidx + 1])
    return eqt.j - sqt.j
end

end
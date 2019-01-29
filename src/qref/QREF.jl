# original (inspired by): 
#   qref.c: Copyright (C) 1991-1995,1997,1998,2000,2001 Tadayoshi Funaba All rights reserved
#   $Id: qref.c,v 1.7 2001-02-06 23:35:44+09 tadf Exp $

module QREF

struct QDInfo
    j::Int
    idx::Int
    y::Int
    m::Int
    leap::Bool
    md::Int
end

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
        m = (j - qt[l].j) * (u - l) ÷ (qt[u].j - qt[l].j) + l
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
        # TODO: throw ArgumentError
        return QDInfo(0, 0, 0, 0, false, 0)
    end
    idx = qi(j - FIRST_JULIAN)
    p = qt[idx]
    m = p.m
    y = p.y + FIRST_YEAR
    md = 1 + j - (p.j + FIRST_JULIAN)
    leap = p.leap
    return QDInfo(j, idx, y, m, leap, md)
end
qref(j::Integer) = qref(Int(j))

function nextmonth(qdinfo::QDInfo)
    idx = qdinfo.idx + 1
    p = qt[idx]
    j = p.j + FIRST_JULIAN
    m = p.m
    y = p.y + FIRST_YEAR
    leap = p.leap
    return QDInfo(j, idx, y, m, leap, 1)
    # Note: returns QDInfo of 1st day of next month
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
    return QDInfo(j, idx, y, 1, false, 1)
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

function rqref(q::QDInfo)
    q.j > 0 && return q.j
    if q.y < FIRST_YEAR || q.y > LAST_YEAR
        # TODO: throw ArgumentError
        return 0
    end
    if !(1 ≤ q.m ≤ 12)
        # TODO: throw ArgumentError
        return 0
    end

    idx = q.idx
    if idx < 1
        idx = rqi(q.y - FIRST_YEAR)
        if q.m > 1 || q.leap
            idx += q.m - 1 + q.leap
            if q.leap && !qt[idx].leap
                return 0
            end
            while !(qt[idx].m == q.m && qt[idx].leap == q.leap)
                idx += 1
            end
        end
    end
	return q.md - 1 + qt[idx].j + FIRST_JULIAN
end
rqref(y::Integer, month::Integer=1, leap::Bool=false, day::Integer=1) = rqref(QDInfo(0, 0, y, month, leap, day))

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

function daysinmonth(q::QDInfo)
    FIRST_RECORD ≤ q.idx ≤ LAST_RECORD || return 0  # TODO: ArgumentError
    qt[q.idx + 1].j - qt[q.idx].j
end

function daysinyear(q::QDInfo)
    sidx = _firstidxofyear(q.idx)
    sqt = qt[sidx]
    eidx = sidx + 12
    eqt = qt[eidx]
    eqt.y == sqt.y && (eqt = qt[eidx + 1])
    return eqt.j - sqt.j
end

end
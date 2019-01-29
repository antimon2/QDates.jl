# arithmetic.jl

function Base.:+(qdt::QDate, y::Year)
    # oy,om,ol,d = yearmonthleapday(qdt)
    qdinfo = QREF.qref(date2jdn(qdt))
    # ny = oy + value(y)
    ny = qdinfo.y + value(y)
    # vd = !ol || _rqref(Cint[FIRST_VALUE+DAYS_OFFSET,ny,0,om,1,0,ol]) > 0
    vd = !qdinfo.leap || QREF.rqref(ny, qdinfo.m, qdinfo.leap, 1).j > 0
    # nm = vd ? om : om + ol
    nm = vd ? qdinfo.m : qdinfo.m + qdinfo.leap
    nl = qdinfo.leap && vd
    ld = daysinmonth(ny, nm, nl)
    return QDate(ny, nm, nl, qdinfo.md <= ld ? qdinfo.md : ld)
end
function Base.:-(qdt::QDate, y::Year)
    # oy,om,ol,d = yearmonthleapday(qdt)
    qdinfo = QREF.qref(date2jdn(qdt))
    # ny = oy - value(y)
    ny = qdinfo.y - value(y)
    # vd = !ol || _rqref(Cint[FIRST_VALUE+DAYS_OFFSET,ny,0,om,1,0,ol]) > 0
    vd = !qdinfo.leap || QREF.rqref(ny, qdinfo.m, qdinfo.leap, 1).j > 0
    # nm = vd ? om : om + ol
    nm = vd ? qdinfo.m : qdinfo.m + qdinfo.leap
    nl = qdinfo.leap && vd
    ld = daysinmonth(ny, nm, nl)
    return QDate(ny, nm, nl, qdinfo.md <= ld ? qdinfo.md : ld)
end

const _DAYS_IN_MONTH_F = 29.530589

function Base.:+(qdt::QDate, m::Month)
    # oy,om,ol,d = yearmonthleapday(qdt)
    oqdinfo = QREF.qref(date2jdn(qdt))
    days = ceil(Int, value(m) * _DAYS_IN_MONTH_F)
    # ny,nm,nl,_ = yearmonthleapday(QDate(UTD(value(qdt)-d+1+days)))
    nqdinfo = QREF.qref(oqdinfo.j - oqdinfo.md + 1 + days)
    ld = daysinmonth(nqdinfo.y, nqdinfo.m, nqdinfo.leap)
    return QDate(nqdinfo.y, nqdinfo.m, nqdinfo.leap, oqdinfo.md <= ld ? oqdinfo.md : ld)
end
function Base.:-(qdt::QDate, m::Month)
    # oy,om,ol,d = yearmonthleapday(qdt)
    oqdinfo = QREF.qref(date2jdn(qdt))
    days = floor(Int, value(m) * _DAYS_IN_MONTH_F)
    # ny,nm,nl,_ = yearmonthleapday(QDate(UTD(value(qdt)-d+2-days)))
    nqdinfo = QREF.qref(oqdinfo.j - oqdinfo.md + 2 - days)
    ld = daysinmonth(nqdinfo.y, nqdinfo.m, nqdinfo.leap)
    return QDate(nqdinfo.y, nqdinfo.m, nqdinfo.leap, oqdinfo.md <= ld ? oqdinfo.md : ld)
end

function Base.:+(qdt::QDate, d::Day)
    QDate(UTD(days(qdt) + value(d)))
end
function Base.:-(qdt::QDate, d::Day)
    QDate(UTD(days(qdt) - value(d)))
end

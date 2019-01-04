# arithmetic.jl

function Base.:+(qdt::QDate,y::Year)
    oy,om,ol,d = yearmonthleapday(qdt)
    ny = oy + value(y)
    vd = !ol || _rqref(Cint[FIRST_VALUE+DAYS_OFFSET,ny,0,om,1,0,ol]) > 0
    nm = vd ? om : om + ol
    nl = ol && vd
    ld = daysinmonth(ny, nm, nl)
    return QDate(ny, nm, nl, d <= ld ? d : ld)
end
function Base.:-(qdt::QDate,y::Year)
    oy,om,ol,d = yearmonthleapday(qdt)
    ny = oy - value(y)
    vd = !ol || _rqref(Cint[FIRST_VALUE+DAYS_OFFSET,ny,0,om,1,0,ol]) > 0
    nm = vd ? om : om + ol
    nl = ol && vd
    ld = daysinmonth(ny, nm, nl)
    return QDate(ny, nm, nl, d <= ld ? d : ld)
end

const _DAYS_IN_MONTH_F = 29.530589

function Base.:+(qdt::QDate,m::Month)
    oy,om,ol,d = yearmonthleapday(qdt)
    days = ceil(Int, value(m) * _DAYS_IN_MONTH_F)
    ny,nm,nl,_ = yearmonthleapday(QDate(UTD(value(qdt)-d+1+days)))
    ld = daysinmonth(ny, nm, nl)
    return QDate(ny, nm, nl, d <= ld ? d : ld)
end
function Base.:-(qdt::QDate,m::Month)
    oy,om,ol,d = yearmonthleapday(qdt)
    days = floor(Int, value(m) * _DAYS_IN_MONTH_F)
    ny,nm,nl,_ = yearmonthleapday(QDate(UTD(value(qdt)-d+2-days)))
    ld = daysinmonth(ny, nm, nl)
    return QDate(ny, nm, nl, d <= ld ? d : ld)
end

function Base.:+(qdt::QDate,d::Day)
    QDate(UTD(days(qdt)+value(d)))
end
function Base.:-(qdt::QDate,d::Day)
    QDate(UTD(days(qdt)-value(d)))
end

# accessors.jl
using Compat.Dates

const year = Dates.year
function year(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[2])
end

const month = Dates.month
function month(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[4])
end

const day = Dates.day
function day(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[5])
end

const yearmonth = Dates.yearmonth
function yearmonth(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]))
end

const monthday = Dates.monthday
function monthday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[4]), Int(cqdate[5]))
end

const yearmonthday = Dates.yearmonthday
function yearmonthday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]), Int(cqdate[5]))
end

function isleapmonth(qdt::QDate)
    cqdate = _qref(qdt)
    cqdate[7] != 0
end

function yearmonthleap(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]), cqdate[7] != 0)
end

function monthleapday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[4]), cqdate[7] != 0, Int(cqdate[5]))
end

function yearmonthleapday(qdt::QDate)
    cqdate = _qref(qdt)
    (Int(cqdate[2]), Int(cqdate[4]), cqdate[7] != 0, Int(cqdate[5]))
end

const days = Dates.days
@inline days(qdt::QDate) = value(qdt)

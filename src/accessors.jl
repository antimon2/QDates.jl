# accessors.jl


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

@inline days(qdt::QDate) = value(qdt)

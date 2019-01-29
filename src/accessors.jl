# accessors.jl
import Dates:
    year,
    month,
    day,
    yearmonth,
    monthday,
    yearmonthday,
    days

function year(qdt::QDate)
    # cqdate = _qref(qdt)
    # Int(cqdate[2])
    qdinfo = QREF.qref(date2jdn(qdt))
    qdinfo.y
end

function month(qdt::QDate)
    # cqdate = _qref(qdt)
    # Int(cqdate[4])
    qdinfo = QREF.qref(date2jdn(qdt))
    qdinfo.m
end

function day(qdt::QDate)
    # cqdate = _qref(qdt)
    # Int(cqdate[5])
    qdinfo = QREF.qref(date2jdn(qdt))
    qdinfo.md
end

function yearmonth(qdt::QDate)
    # cqdate = _qref(qdt)
    # (Int(cqdate[2]), Int(cqdate[4]))
    qdinfo = QREF.qref(date2jdn(qdt))
    (qdinfo.y, qdinfo.m)
end

function monthday(qdt::QDate)
    # cqdate = _qref(qdt)
    # (Int(cqdate[4]), Int(cqdate[5]))
    qdinfo = QREF.qref(date2jdn(qdt))
    (qdinfo.m, qdinfo.md)
end

function yearmonthday(qdt::QDate)
    # cqdate = _qref(qdt)
    # (Int(cqdate[2]), Int(cqdate[4]), Int(cqdate[5]))
    qdinfo = QREF.qref(date2jdn(qdt))
    (qdinfo.y, qdinfo.m, qdinfo.md)
end

function isleapmonth(qdt::QDate)
    # cqdate = _qref(qdt)
    # cqdate[7] != 0
    qdinfo = QREF.qref(date2jdn(qdt))
    qdinfo.leap
end

function yearmonthleap(qdt::QDate)
    # cqdate = _qref(qdt)
    # (Int(cqdate[2]), Int(cqdate[4]), cqdate[7] != 0)
    qdinfo = QREF.qref(date2jdn(qdt))
    (qdinfo.y, qdinfo.m, qdinfo.leap)
end

function monthleapday(qdt::QDate)
    # cqdate = _qref(qdt)
    # (Int(cqdate[4]), cqdate[7] != 0, Int(cqdate[5]))
    qdinfo = QREF.qref(date2jdn(qdt))
    (qdinfo.m, qdinfo.leap, qdinfo.md)
end

function yearmonthleapday(qdt::QDate)
    # cqdate = _qref(qdt)
    # (Int(cqdate[2]), Int(cqdate[4]), cqdate[7] != 0, Int(cqdate[5]))
    qdinfo = QREF.qref(date2jdn(qdt))
    (qdinfo.y, qdinfo.m, qdinfo.leap, qdinfo.md)
end

@inline days(qdt::QDate) = value(qdt)

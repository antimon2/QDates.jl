# query.jl
using Compat.Dates

### Days of week
const 先勝,友引,先負,仏滅,大安,赤口 = 1,2,3,4,5,6
const qdaysofweek = Dict(1=>"先勝",2=>"友引",3=>"先負",4=>"仏滅",5=>"大安",6=>"赤口")

dayname(dt::Integer) = qdaysofweek[dt]
dayabbr(dt::Integer) = qdaysofweek[dt]
dayname(qdt::QDate) = qdaysofweek[dayofweek(qdt)]
dayabbr(qdt::QDate) = qdaysofweek[dayofweek(qdt)]

# Days of week from 先勝 = 1 to 赤口 = 6
function dayofweek(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[6]) + 1
end

# define is先勝/is友引/is先負/is仏滅/is大安/is赤口
for (dow, nm) in qdaysofweek
    @eval ($(Symbol("is$nm")))(qdt::QDate) = dayofweek(qdt) == $dow
end

### Months
const 睦月,如月,弥生,卯月,皐月,水無月 = 1,2,3,4,5,6
const 文月,葉月,長月,神無月,霜月,師走 = 7,8,9,10,11,12
const qmonths = Dict(1=>"睦月",2=>"如月",3=>"弥生",4=>"卯月",5=>"皐月",6=>"水無月",
                     7=>"文月",8=>"葉月",9=>"長月",10=>"神無月",11=>"霜月",12=>"師走")
const leap_prefix = "閏"
monthname(dt::Integer, leap::Bool=false) = leap ? (leap_prefix * qmonths[dt]) : qmonths[dt]
@inline monthabbr(dt::Integer, leap::Bool=false) = monthname(dt, leap)
function monthname(qdt::QDate)
    cqdate = _qref(qdt)
    monthname(cqdate[4], (cqdate[7] != 0))
end
function monthabbr(qdt::QDate)
    cqdate = _qref(qdt)
    monthabbr(cqdate[4], (cqdate[7] != 0))
end

function daysinmonth(y::Integer, m::Integer, leap::Bool=false)
    y1 = y
    m1 = m + 1
    if m1 > 12
        y1 += 1
        m1 = 1
        if y1 > LAST_YEAR
            # 2100/12 is privilleged
            return leap ? 0 : 1
        end
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
function daysinmonth(qdt::QDate)
    cqdate = _qref(qdt)
    daysinmonth(cqdate[2], cqdate[4], (cqdate[7] != 0))
end

function isleapyear(y::Integer)
    any(1:12) do m
        qarr0 = Cint[FIRST_VALUE+DAYS_OFFSET,y,0,m,1,0,1]
        _rqref(qarr0) > 0
    end
end
function isleapyear(qdt::QDate)
    cqdate = _qref(qdt)
    isleapyear(cqdate[2])
end

function daysinyear(qdt::QDate)
    cqdate = _qref(qdt)
    # sum(daysinmonth(cqdate[2], m, l) for m=1:12, l=false:true)
    jdn0 = _rqref(Cint[cqdate[1],cqdate[2],0,1,1,0,0])
    if cqdate[2] == 2100
        # privilleged 2100/xx
        _rqref(Cint[cqdate[1],cqdate[2],0,12,1,0,0]) - jdn0 + 1
    else
        _rqref(Cint[cqdate[1],cqdate[2]+1,0,1,1,0,0]) - jdn0
    end
end

function monthsinyear(qdt::QDate)
    daysinyear(qdt) ÷ 29
end

dayofyear(y::Integer, m::Integer, d::Integer) = dayofyear(y, m, false, d)
function dayofyear(y::Integer, m::Integer, l::Bool, d::Integer=1)
    qarr0 = Cint[FIRST_VALUE+DAYS_OFFSET,y,0,m,d,0,l]
    cqdate = _qref(_rqref(qarr0))
    Int(cqdate[3])
end
function dayofyear(qdt::QDate)
    cqdate = _qref(qdt)
    Int(cqdate[3])
end

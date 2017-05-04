# adjusters.jl

#trunc
qdt = QDates.QDate(2012,12,21)
@test trunc(qdt, Dates.Year) == QDates.QDate(2012)
@test trunc(qdt, Dates.Month) == QDates.QDate(2012,12)
@test trunc(qdt, Dates.Day) == QDates.QDate(2012,12,21)

# Date functions
# Name functions
mtk = QDates.QDate(2017,1,1)
ksrg = QDates.QDate(2017,2,2)
yyi = QDates.QDate(2017,3,3)
udk = QDates.QDate(2017,4,4)
stk = QDates.QDate(2017,5,5)
lstk = QDates.QDate(2017,5,true,6)
mndk = QDates.QDate(2017,6,7)
fdk = QDates.QDate(2017,7,8)
hdk = QDates.QDate(2017,8,9)
ngtk = QDates.QDate(2017,9,10)
kmndk = QDates.QDate(2017,10,11)
smtk = QDates.QDate(2017,11,12)
sws = QDates.QDate(2017,12,13)

@test QDates.lastdayofmonth(mtk) == QDates.QDate(2017,1,29)
@test QDates.lastdayofmonth(ksrg) == QDates.QDate(2017,2,30)
@test QDates.lastdayofmonth(yyi) == QDates.QDate(2017,3,29)
@test QDates.lastdayofmonth(udk) == QDates.QDate(2017,4,30)
@test QDates.lastdayofmonth(stk) == QDates.QDate(2017,5,29)
@test QDates.lastdayofmonth(lstk) == QDates.QDate(2017,5,true,29)
@test QDates.lastdayofmonth(mndk) == QDates.QDate(2017,6,30)
@test QDates.lastdayofmonth(fdk) == QDates.QDate(2017,7,29)
@test QDates.lastdayofmonth(hdk) == QDates.QDate(2017,8,30)
@test QDates.lastdayofmonth(ngtk) == QDates.QDate(2017,9,29)
@test QDates.lastdayofmonth(kmndk) == QDates.QDate(2017,10,30)
@test QDates.lastdayofmonth(smtk) == QDates.QDate(2017,11,30)
@test QDates.lastdayofmonth(sws) == QDates.lastdayofyear(mtk) == QDates.QDate(2017,12,30)

@test QDates.firstdayofmonth(mtk) == QDates.firstdayofyear(sws) == QDates.QDate(2017,1,1)
@test QDates.firstdayofmonth(ksrg) == QDates.QDate(2017,2,1)
@test QDates.firstdayofmonth(yyi) == QDates.QDate(2017,3,1)
@test QDates.firstdayofmonth(udk) == QDates.QDate(2017,4,1)
@test QDates.firstdayofmonth(stk) == QDates.QDate(2017,5,1)
@test QDates.firstdayofmonth(lstk) == QDates.QDate(2017,5,true,1)
@test QDates.firstdayofmonth(mndk) == QDates.QDate(2017,6,1)
@test QDates.firstdayofmonth(fdk) == QDates.QDate(2017,7,1)
@test QDates.firstdayofmonth(hdk) == QDates.QDate(2017,8,1)
@test QDates.firstdayofmonth(ngtk) == QDates.QDate(2017,9,1)
@test QDates.firstdayofmonth(kmndk) == QDates.QDate(2017,10,1)
@test QDates.firstdayofmonth(smtk) == QDates.QDate(2017,11,1)
@test QDates.firstdayofmonth(sws) == QDates.QDate(2017,12,1)

# # Adjusters
# # Adjuster Constructors # Not implemented
# @test QDates.QDate(Dates.isXXXX,2014) == QDates.QDate(2014,XX,XX)
# @test QDates.QDate(Dates.isYYYY,2014,5) == QDates.QDate(2014,5,YY)

# tonext, toprev, tofirst, tolast
qdt = QDates.QDate(2017,5,3)
@test Dates.tonext(qdt, QDates.先勝) == QDates.QDate(2017,5,9)
@test Dates.tonext(qdt, QDates.先勝; same=true) == qdt
@test Dates.tonext(qdt, QDates.友引) == QDates.QDate(2017,5,4)
@test Dates.tonext(qdt, QDates.先負) == QDates.QDate(2017,5,5)
@test Dates.tonext(qdt, QDates.仏滅) == QDates.QDate(2017,5,6)
@test Dates.tonext(qdt, QDates.大安) == QDates.QDate(2017,5,7)
@test Dates.tonext(qdt, QDates.赤口) == QDates.QDate(2017,5,8)
# No dayofweek function for out of range values
@test_throws KeyError Dates.tonext(qdt, 7)

#test func, diff steps, negate, same
@test Dates.tonext(QDates.is先勝, qdt) == QDates.QDate(2017,5,9)
@test Dates.tonext(QDates.is先勝, qdt; same=true) == qdt
@test Dates.tonext(QDates.is友引, qdt) == QDates.QDate(2017,5,4)
@test Dates.tonext(QDates.is先負, qdt) == QDates.QDate(2017,5,5)
@test Dates.tonext(QDates.is仏滅, qdt) == QDates.QDate(2017,5,6)
@test Dates.tonext(QDates.is大安, qdt) == QDates.QDate(2017,5,7)
@test Dates.tonext(QDates.is赤口, qdt) == QDates.QDate(2017,5,8)
@test Dates.tonext(QDates.isleapmonth, qdt) == QDates.QDate(2017,5,true,1)
@test Dates.tonext(QDates.isleapmonth, qdt; step=Dates.Month(1)) == QDates.QDate(2017,5,true,3)

@test Dates.tonext(x->!QDates.is大安(x), qdt; negate=true) == QDates.QDate(2017,5,7)
# Reach adjust limit
@test_throws ArgumentError Dates.tonext(QDates.is大安, qdt; limit=3)

#toprev
@test Dates.toprev(qdt, QDates.先勝) == QDates.QDate(2017,4,28)
@test Dates.toprev(qdt, QDates.先勝; same=true) == qdt
@test Dates.toprev(qdt, QDates.友引) == QDates.QDate(2017,4,29)
@test Dates.toprev(qdt, QDates.先負) == QDates.QDate(2017,4,30)
@test Dates.toprev(qdt, QDates.仏滅) == QDates.QDate(2017,4,25)
@test Dates.toprev(qdt, QDates.大安) == QDates.QDate(2017,5,1)
@test Dates.toprev(qdt, QDates.赤口) == QDates.QDate(2017,5,2)
# No dayofweek function for out of range values
@test_throws KeyError Dates.toprev(qdt, 8)

#tofirst
@test Dates.tofirst(qdt, QDates.先勝) == QDates.QDate(2017,5,3)
@test Dates.tofirst(qdt, QDates.友引) == QDates.QDate(2017,5,4)
@test Dates.tofirst(qdt, QDates.先負) == QDates.QDate(2017,5,5)
@test Dates.tofirst(qdt, QDates.仏滅) == QDates.QDate(2017,5,6)
@test Dates.tofirst(qdt, QDates.大安) == QDates.QDate(2017,5,1)
@test Dates.tofirst(qdt, QDates.赤口) == QDates.QDate(2017,5,2)

@test Dates.tofirst(qdt, QDates.先勝, of=Dates.Year) == QDates.QDate(2017,1,1)
@test Dates.tofirst(qdt, QDates.友引, of=Dates.Year) == QDates.QDate(2017,1,2)
@test Dates.tofirst(qdt, QDates.先負, of=Dates.Year) == QDates.QDate(2017,1,3)
@test Dates.tofirst(qdt, QDates.仏滅, of=Dates.Year) == QDates.QDate(2017,1,4)
@test Dates.tofirst(qdt, QDates.大安, of=Dates.Year) == QDates.QDate(2017,1,5)
@test Dates.tofirst(qdt, QDates.赤口, of=Dates.Year) == QDates.QDate(2017,1,6)

#tolast
@test Dates.tolast(qdt, QDates.先勝) == QDates.QDate(2017,5,27)
@test Dates.tolast(qdt, QDates.友引) == QDates.QDate(2017,5,28)
@test Dates.tolast(qdt, QDates.先負) == QDates.QDate(2017,5,29)
@test Dates.tolast(qdt, QDates.仏滅) == QDates.QDate(2017,5,24)
@test Dates.tolast(qdt, QDates.大安) == QDates.QDate(2017,5,25)
@test Dates.tolast(qdt, QDates.赤口) == QDates.QDate(2017,5,26)

@test Dates.tolast(qdt, QDates.先勝, of=Dates.Year) == QDates.QDate(2017,12,26)
@test Dates.tolast(qdt, QDates.友引, of=Dates.Year) == QDates.QDate(2017,12,27)
@test Dates.tolast(qdt, QDates.先負, of=Dates.Year) == QDates.QDate(2017,12,28)
@test Dates.tolast(qdt, QDates.仏滅, of=Dates.Year) == QDates.QDate(2017,12,29)
@test Dates.tolast(qdt, QDates.大安, of=Dates.Year) == QDates.QDate(2017,12,30)
@test Dates.tolast(qdt, QDates.赤口, of=Dates.Year) == QDates.QDate(2017,12,25)

# recur
startdate = QDates.QDate(2014,1,1)
stopdate = QDates.QDate(2014,2,1)
@test length(Dates.recur(x->true,startdate:stopdate)) == 30
@test length(Dates.recur(x->true,stopdate:Dates.Day(-1):startdate)) == 30

mtk大安s2014 = [QDates.QDate(2014,1,5),QDates.QDate(2014,1,11),QDates.QDate(2014,1,17),QDates.QDate(2014,1,23),QDates.QDate(2014,1,29)]
@test Dates.recur(QDates.is大安,startdate,stopdate) == mtk大安s2014
@test Dates.recur(QDates.is大安,startdate:stopdate) == mtk大安s2014
@test Dates.recur(x->!QDates.is大安(x),startdate,stopdate;negate=true) == mtk大安s2014

@test_throws MethodError Dates.recur((x,y)->x+y,QDates.QDate(2013):QDates.QDate(2014))
@test_throws MethodError Dates.DateFunction((x,y)->x+y, false, Date(0))
@test_throws ArgumentError Dates.DateFunction((dt)->2, false, Date(0))
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,2))) == 31
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,1))) == 1
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,2))) == 2
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,3))) == 3
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,4))) == 4
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,5))) == 5
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,6))) == 6
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,7))) == 7
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2013,1,8))) == 8
@test length(Dates.recur(x->true,QDates.QDate(2013):Dates.Month(1):QDates.QDate(2013,1,1))) == 1
@test length(Dates.recur(x->true,QDates.QDate(2013):Dates.Day(-1):QDates.QDate(2012,1,1))) == 385
# Empty range
@test length(Dates.recur(x->true,QDates.QDate(2013):QDates.QDate(2012,1,1))) == 0

# All leap months/years in 20th century
@test length(Dates.recur(QDates.QDate(1901):Dates.Month(1):QDates.QDate(2000)) do x
    QDates.isleapmonth(x)
end) == length(Dates.recur(QDates.QDate(1901):Dates.Year(1):QDates.QDate(2000)) do x
    QDates.isleapyear(x)
end) == 36

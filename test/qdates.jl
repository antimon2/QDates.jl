qdt = QDate(Dates.UTD(736440))
@test Dates.value(qdt) == 736440
@test Dates.year(qdt) == 2017
@test Dates.month(qdt) == 3
@test Dates.day(qdt) == 25
@test Dates.week(qdt) == 3
@test Dates.yearmonth(qdt) == (2017, 3)
@test Dates.monthday(qdt) == (3, 25)
@test Dates.yearmonthday(qdt) == (2017, 3, 25)
@test QDates.isleapmonth(qdt) == false
@test QDates.yearmonthleapday(qdt) == (2017, 3, false, 25)

qdt = QDate(Dates.UTD(736504))
@test Dates.value(qdt) == 736504
@test Dates.year(qdt) == 2017
@test Dates.month(qdt) == 5
@test Dates.day(qdt) == 1
@test Dates.week(qdt) == 5
@test Dates.yearmonth(qdt) == (2017, 5)
@test Dates.monthday(qdt) == (5, 1)
@test Dates.yearmonthday(qdt) == (2017, 5, 1)
@test QDates.isleapmonth(qdt) == true
@test QDates.yearmonthleapday(qdt) == (2017, 5, true, 1)

qdt = QDate(2017, 3, 25)
@test Dates.value(qdt) == 736440
dt = convert(Date, qdt)
@test Dates.yearmonthday(dt) == (2017, 4, 21)

qdt = QDate(2017, 5, true, 1)
@test Dates.value(qdt) == 736504
dt = convert(Date, qdt)
@test Dates.yearmonthday(dt) == (2017, 6, 24)

qdt1 = QDate(qdt)
@test qdt1 === qdt

qdt0 = QDate(Date(2017, 5))
qdt1 = QDate(Date(2017, 5, 1))
qdt2 = QDate(Date(2017, 5, 2))
@test qdt0 == qdt1
@test qdt0 != qdt2
@test qdt0 < qdt2

qdt0 = QDates.today()
qdt1 = QDates.today(QDate)
qdt2 = Dates.today(QDate)
@test qdt0 == qdt1 == qdt2

@test Dates.today() == Dates.today(Date) == QDates.today(Date)

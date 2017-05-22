# conversions.jl

# Test conversion to and from Julian-Date-Number
@test QDates.date2jdn(QDates.jdn2date(2457875)) == 2457875
@test QDates.qdate2jdn(QDates.jdn2qdate(2457875)) == 2457875
@test QDates.jdn2date(QDates.date2jdn(Dates.Date(2017,5,1))) == Dates.Date(2017,5,1)
@test QDates.jdn2qdate(QDates.qdate2jdn(QDates.QDate(2017,5,true,1))) == QDates.QDate(2017,5,true,1)

dt = Dates.Date(2017,5,1)
@test QDates.date2jdn(dt) == round(Int, Dates.datetime2julian(DateTime(dt)), RoundNearestTiesUp)

@test typeof(QDates.today()) <: QDates.QDate
@test typeof(QDates.today(Dates.Date)) <: Dates.Date
@test typeof(QDates.today(QDates.QDate)) <: QDates.QDate
# @test typeof(Dates.today()) <: Dates.Date
@test typeof(Dates.today(Dates.Date)) <: Dates.Date
@test typeof(Dates.today(QDates.QDate)) <: QDates.QDate

# Conversions to/from Date/DateTime
dt = Dates.Date(2017,5,26)
dttm = Dates.DateTime(2017,5,26)
qdt = QDates.QDate(2017,5,1)
@test convert(Dates.Date, qdt) == dt
@test Dates.Date(qdt) == dt
@test convert(Dates.DateTime, qdt) == dttm
@test Dates.DateTime(qdt) == dttm
@test convert(QDates.QDate, dt) == qdt
@test QDates.QDate(dt) == qdt
@test convert(QDates.QDate, dttm) == qdt
@test QDates.QDate(dttm) == qdt

# Conversions to/from numbers
b = QDates.QDate(2017)
@test convert(Real,b) == 736357
@test convert(Float64,b) == 736357.0
@test convert(Int32,b) == 736357
@test convert(QDate,736357) == b
@test convert(QDate,736357.0) == b
@test convert(QDate,Int32(736357)) == b
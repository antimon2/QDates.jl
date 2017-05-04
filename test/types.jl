@test QDates.daysinmonth(2001,1) == 30
@test QDates.daysinmonth(2001,2) == 30
@test QDates.daysinmonth(2001,3) == 30
@test QDates.daysinmonth(2001,4) == 29
@test QDates.daysinmonth(2001,4,true) == 29
@test QDates.daysinmonth(2001,5) == 30
@test QDates.daysinmonth(2001,6) == 29
@test QDates.daysinmonth(2001,7) == 29
@test QDates.daysinmonth(2001,8) == 30
@test QDates.daysinmonth(2001,9) == 29
@test QDates.daysinmonth(2001,10) == 30
@test QDates.daysinmonth(2001,11) == 29
@test QDates.daysinmonth(2001,12) == 30
@test QDates.daysinmonth(2002,1) == 30
@test QDates.daysinmonth(2002,1,true) == 0

# Create "test" check manually
test = QDates.QDate(Dates.UTD(734909))
# Test Date construction by parts
@test QDates.QDate(2013) == test
@test QDates.QDate(2013,1) == test
@test QDates.QDate(2013,1,1) == test

# Test various input types for Date/DateTime
test = QDates.QDate(2017,1,1)
@test QDates.QDate(2017,Int8(1),Int8(1)) == test
@test QDates.QDate(2017,UInt8(1),UInt8(1)) == test
@test QDates.QDate(Int16(2017),Int16(1),Int16(1)) == test
@test QDates.QDate(UInt16(2017),UInt8(1),UInt8(1)) == test
@test QDates.QDate(Int32(2017),Int32(1),Int32(1)) == test
@test QDates.QDate(UInt32(2017),UInt32(1),UInt32(1)) == test
@test QDates.QDate(Int64(2017),Int64(1),Int64(1)) == test
@test QDates.QDate('\u07e1','\x01','\x01') == test
@test QDates.QDate(2017,true,true) == test
@test_throws ArgumentError QDates.QDate(2017,true,false)
@test QDates.QDate(UInt64(2017),UInt64(1),UInt64(1)) == test
@test QDates.QDate(Int128(2017),Int128(1),Int128(1)) == test
@test_throws InexactError QDates.QDate(170141183460469231731687303715884105727,Int128(1),Int128(1))
@test QDates.QDate(UInt128(2017),UInt128(1),UInt128(1)) == test
@test QDates.QDate(big(2017),big(1),big(1)) == test
@test QDates.QDate(big(2017),big(1),big(1)) == test
# Potentially won't work if can't losslessly convert to Int64
@test QDates.QDate(BigFloat(2017),BigFloat(1),BigFloat(1)) == test
@test QDates.QDate(complex(2017),complex(1),complex(1)) == test
@test QDates.QDate(Float64(2017),Float64(1),Float64(1)) == test
@test QDates.QDate(Float32(2017),Float32(1),Float32(1)) == test
@test QDates.QDate(Float16(2017),Float16(1),Float16(1)) == test
@test QDates.QDate(Rational(2017),Rational(1),Rational(1)) == test
@test_throws InexactError QDates.QDate(BigFloat(1.2),BigFloat(1),BigFloat(1))
@test_throws InexactError QDates.QDate(1 + im,complex(1),complex(1))
@test_throws InexactError QDates.QDate(1.2,1.0,1.0)
@test_throws InexactError QDates.QDate(1.2f0,1.f0,1.f0)
@test_throws InexactError QDates.QDate(3//4,Rational(1),Rational(1)) == test

# Value must be in range
@test_throws ArgumentError QDates.QDate(Dates.UTD(QDates.FIRST_VALUE - 1))
@test_throws ArgumentError QDates.QDate(Dates.UTD(QDates.LAST_VALUE + 1))
# Months and days must be in range
@test_throws ArgumentError QDates.QDate(444,1,1)
@test_throws ArgumentError QDates.QDate(2101,1,1)
@test_throws ArgumentError QDates.QDate(2013,0,1)
@test_throws ArgumentError QDates.QDate(2013,13,1)
@test_throws ArgumentError QDates.QDate(2013,1,0)
@test_throws ArgumentError QDates.QDate(2013,1,32)
@test_throws ArgumentError QDates.QDate(2017,6,true,1)

# Test DateTime traits
a = Dates.Date(2000, 2, 5)
b = QDates.QDate(2000, 1, 1)
# @test Dates.calendar(a) == Dates.ISOCalendar
# @test Dates.calendar(b) == ???
@test eps(b) == Dates.Day(1)
@test string(typemax(QDates.QDate)) == "旧2100年12月01日"
@test string(typemin(QDates.QDate)) == "旧0445年01月01日"
@test typemax(QDates.QDate) - typemin(QDates.QDate) == Dates.Day(604816)

# Date-QDate conversion
@test QDates.QDate(a) == b
@test Dates.Date(b) == a
@test a != b    # cannot promote

c = QDates.QDate(2001)
@test b < c

y = Dates.Year(2017)
m = Dates.Month(5)
d = Dates.Day(1)
l = true  # Leap-Month
@test QDates.QDate(y) == QDates.QDate(2017)
@test QDates.QDate(y,m) == QDates.QDate(2017,5)
@test QDates.QDate(y,m,d) == QDates.QDate(2017,5,1)
@test QDates.QDate(y,m,l,d) == QDates.QDate(2017,5,true,1)
@test QDates.QDate(d,y) == QDates.QDate(2017,1,1)
@test QDates.QDate(m,y) == QDates.QDate(2017,5,1)
@test QDates.QDate(m,l,y) == QDates.QDate(2017,5,true,1)
@test_throws ArgumentError QDates.QDate(m)
@test_throws ArgumentError QDates.QDate(d,m)
@test_throws ArgumentError QDates.QDate(d,m,l)
@test_throws ArgumentError QDates.QDate(y,l)

@test isfinite(QDates.QDate)
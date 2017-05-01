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

# Months, days, hours, minutes, seconds, and milliseconds must be in range
@test_throws ArgumentError QDates.QDate(444,1,1)
@test_throws ArgumentError QDates.QDate(2101,1,1)
@test_throws ArgumentError QDates.QDate(2013,0,1)
@test_throws ArgumentError QDates.QDate(2013,13,1)
@test_throws ArgumentError QDates.QDate(2013,1,0)
@test_throws ArgumentError QDates.QDate(2013,1,32)
@test_throws ArgumentError QDates.QDate(2017,6,true,1)

# # # Test DateTime traits
# # a = Dates.DateTime(2000)
# # b = Dates.Date(2000)
# # @test Dates.calendar(a) == Dates.ISOCalendar
# # @test Dates.calendar(b) == Dates.ISOCalendar
# # @test eps(a) == Dates.Millisecond(1)
# # @test eps(b) == Dates.Day(1)
# # @test string(typemax(Dates.DateTime)) == "146138512-12-31T23:59:59"
# # @test string(typemin(Dates.DateTime)) == "-146138511-01-01T00:00:00"
# # @test typemax(Dates.DateTime) - typemin(Dates.DateTime) == Dates.Millisecond(9223372017043199000)
# # @test string(typemax(Dates.Date)) == "252522163911149-12-31"
# # @test string(typemin(Dates.Date)) == "-252522163911150-01-01"

# # # Date-DateTime conversion/promotion
# # @test Dates.DateTime(a) == a
# # @test Dates.Date(a) == b
# # @test Dates.DateTime(b) == a
# # @test Dates.Date(b) == b
# # @test a == b
# # @test a == a
# # @test b == a
# # @test b == b
# # @test !(a < b)
# # @test !(b < a)
# # c = Dates.DateTime(2000)
# # d = Dates.Date(2000)
# # @test ==(a,c)
# # @test ==(c,a)
# # @test ==(d,b)
# # @test ==(b,d)
# # @test ==(a,d)
# # @test ==(d,a)
# # @test ==(b,c)
# # @test ==(c,b)
# # b = Dates.Date(2001)
# # @test b > a
# # @test a < b
# # @test a != b
# # @test Dates.Date(Dates.DateTime(Dates.Date(2012,7,1))) == Dates.Date(2012,7,1)

# # y = Dates.Year(1)
# # m = Dates.Month(1)
# # w = Dates.Week(1)
# # d = Dates.Day(1)
# # h = Dates.Hour(1)
# # mi = Dates.Minute(1)
# # s = Dates.Second(1)
# # ms = Dates.Millisecond(1)
# # @test Dates.DateTime(y) == Dates.DateTime(1)
# # @test Dates.DateTime(y,m) == Dates.DateTime(1,1)
# # @test Dates.DateTime(y,m,d) == Dates.DateTime(1,1,1)
# # @test Dates.DateTime(y,m,d,h) == Dates.DateTime(1,1,1,1)
# # @test Dates.DateTime(y,m,d,h,mi) == Dates.DateTime(1,1,1,1,1)
# # @test Dates.DateTime(y,m,d,h,mi,s) == Dates.DateTime(1,1,1,1,1,1)
# # @test Dates.DateTime(y,m,d,h,mi,s,ms) == Dates.DateTime(1,1,1,1,1,1,1)
# # @test Dates.DateTime(Dates.Day(10),Dates.Month(2),y) == Dates.DateTime(1,2,10)
# # @test Dates.DateTime(Dates.Second(10),Dates.Month(2),y,Dates.Hour(4)) == Dates.DateTime(1,2,1,4,0,10)
# # @test Dates.DateTime(Dates.Year(1),Dates.Month(2),Dates.Day(1),
# #                      Dates.Hour(4),Dates.Second(10)) == Dates.DateTime(1,2,1,4,0,10)
# # @test Dates.Date(y) == Dates.Date(1)
# # @test Dates.Date(y,m) == Dates.Date(1,1)
# # @test Dates.Date(y,m,d) == Dates.Date(1,1,1)
# # @test Dates.Date(m) == Dates.Date(1,1,1)
# # @test Dates.Date(d,y) == Dates.Date(1,1,1)
# # @test Dates.Date(d,m) == Dates.Date(1,1,1)
# # @test Dates.Date(m,y) == Dates.Date(1,1,1)

# # @test isfinite(Dates.Date)
# # @test isfinite(Dates.DateTime)
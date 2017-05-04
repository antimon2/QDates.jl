# conversions.jl

@inline date2jdn(dt::Union{Date,QDate}) = value(dt) + DAYS_OFFSET
@inline qdate2jdn(qdt::QDate) = date2jdn(qdt)

@inline jdn2date(j::Integer) = Dates.Date(Dates.UTD(j - DAYS_OFFSET))
@inline jdn2qdate(j::Integer) = QDates.QDate(Dates.UTD(j - DAYS_OFFSET))

Base.convert(::Type{Date}, qdt::QDate) = Date(qdt.instant)
Base.convert(::Type{QDate}, dt::Date) = QDate(dt.instant)
Base.convert(::Type{DateTime}, qdt::QDate) = DateTime(UTM(value(qdt)*86400000))
Base.convert(::Type{QDate}, dt::DateTime) = QDate(UTD(days(dt)))

Base.convert{R<:Real}(::Type{R}, qdt::QDate) = convert(R, value(qdt))
Base.convert{R<:Real}(::Type{QDate}, x::R) = QDate(UTD(x))

@inline Date(qdt::QDate) = convert(Date, qdt)
@inline QDate(dt::Date) = convert(QDate, dt)
@inline DateTime(qdt::QDate) = convert(DateTime, qdt)
@inline QDate(dt::DateTime) = convert(QDate, dt)

today() = QDate(Dates.now())
@inline today(::Type{QDate}) = today()
today(::Type{Date}) = Dates.today()
Base.Dates.today(::Type{QDate}) = today()
@inline Base.Dates.today(::Type{Date}) = Dates.today()

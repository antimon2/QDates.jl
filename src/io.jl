# io.jl

function Base.string(qdt::QDate)
    y, m, l, d = yearmonthleapday(qdt)
    yy = lpad(y, 4, "0")
    mm = lpad(m, 2, "0")
    dd = lpad(d, 2, "0")
    return l ? "$yy-L$mm-$dd" : "$yy-$mm-$dd"
end
Base.show(io::IO, qdt::QDate) = print(io, string(qdt))

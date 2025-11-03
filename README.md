QDates
======

[![Build Status](https://travis-ci.org/antimon2/QDates.jl.svg?branch=master)](https://travis-ci.org/antimon2/QDates.jl) [![Build status](https://ci.appveyor.com/api/projects/status/github/antimon2/QDates.jl?branch=master)](https://ci.appveyor.com/project/antimon2/qdates-jl/branch/master)  [![Cirrus](https://api.cirrus-ci.com/github/antimon2/QDates.jl.svg)](https://cirrus-ci.com/github/antimon2/QDates.jl)  
[![Coverage Status](https://coveralls.io/repos/antimon2/QDates.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/antimon2/QDates.jl?branch=master) [![codecov.io](http://codecov.io/github/antimon2/QDates.jl/coverage.svg?branch=master)](http://codecov.io/github/antimon2/QDates.jl?branch=master)

The **QDates** package provides Japanese "Kyūreki (旧暦)" calendrical calculations into Julia.  
"Kyūreki (旧暦)" is one of the Lunisolar Calendar that has been once used in Japan.


## Installation

To install the release version, simply run on the Julia Pkg REPL-mode:

```julia
pkg> add QDates
```

To install the latest development version, run the following command instead:

```julia
pkg> add QDates#master
```

Then you can run the built-in unit tests with

```julia
pkg> test QDates
```

to verify that everything is functioning properly on your machine.


## Usage

`QDates` has APIs almost compatible with the standard `Dates` package.

```julia
using QDates

### construct Kyūreki Date
qdt = QDate(2017, 5, 1)
# => 旧2017年05月01日

### get year/month/day values
using Dates
Dates.yearmonthday(qdt)
# => (2017,5,1)

### check leapmonth or not
QDates.isleapmonth(qdt)
# => false

### arithmetic
qdt1 = qdt + Dates.Month(1)
# => 旧2017年閏05月01日

### check leapmonth or not
QDates.isleapmonth(qdt1)
# => true

### get year/month/isleapmonth/day values
QDates.yearmonthleapday(qdt1)
# => (2017,5,true,1)

### comparison (with constructing leapmonth-date)
qdt1 == QDate(2017, 5, true, 1)
# => true

### conversion to Gregorian Date
dt = Date(qdt)
# => 2017-05-26

### conversion from Gregorian Date
qdt0 = QDate(dt)
# => 旧2017年05月01日

### get today
qtoday = QDates.today()
# => 旧2017年04月10日
qtoday == QDate(Dates.today())
# => true

### six-day week system
[QDates.dayname(d) for d=qdt:QDate(2017,5,7)]
# => 7-element Array{String,1}:
#     "大安"
#     "赤口"
#     "先勝"
#     "友引"
#     "先負"
#     "仏滅"
#     "大安"

[d for d=qdt:qdt1 if QDates.is大安(d)]
# => 6-element Array{QDates.QDate,1}:
#     旧2017年05月01日
#     旧2017年05月07日
#     旧2017年05月13日
#     旧2017年05月19日
#     旧2017年05月25日
#     旧2017年閏05月01日

### month names (old-fashioned)
[QDates.monthname(m) for m=QDate(2017,1):Dates.Month(1):QDate(2017,12)]
# => 13-element Array{String,1}:
#     "睦月"
#     "如月"
#     "弥生"
#     "卯月"
#     "皐月"
#     "閏皐月" # <- means leapmonth("閏月") of "皐月"
#     "水無月"
#     "文月"
#     "葉月"
#     "長月"
#     "神無月"
#     "霜月"
#     "師走"

### The number of days in a month (29 or 30, not constant).
[QDates.daysinmonth(m) for m=QDate(2017,1):Dates.Month(1):QDate(2017,12)]
# => 13-element Array{Int64,1}:
#     29 # 1月
#     30 # 2月
#     29 # 3月
#     30 # 4月
#     29 # 5月
#     29 # 閏5月
#     30 # 6月
#     29 # 7月
#     30 # 8月
#     29 # 9月
#     30 # 10月
#     30 # 11月
#     30 # 12月

### leapyear or not (⇔ including leapmonth or not, not constant)
[QDates.isleapyear(y) for y=QDate(2011):Dates.Year(1):QDate(2020)]
# => 10-element Array{Bool,1}:
#     false # 2011
#      true # 2012
#     false # 2013
#      true # 2014
#     false # 2015
#     false # 2016
#      true # 2017
#     false # 2018
#     false # 2019
#      true # 2020

```


## Installation as CLI (for Julia ≥ v1.12)

To install `qdate` CLI command, run it on the Julia Pkg REPL-mode:

```julia
pkg> app add QDates
```


### Usage

```shell
$ qdate
今日は 旧2025年09月14日、仏滅 です。

$  qdate 今日 明日 2112/9/3 1970-1-1 100日後 100日前
今日 は、旧2025年09月14日、仏滅 です。
明日 は、旧2025年09月15日、大安 です。
2112/9/3 は、旧2112年07月13日、先勝 です。
1970-1-1 は、旧1969年11月24日、仏滅 です。
100日後 は、旧2025年12月24日、大安 です。
100日前 は、旧2025年閏06月02日、先勝 です。
```


### For `juliac`

You can compile `qdate` command with [juliac](https://github.com/JuliaLang/JuliaC.jl) as follows (for example):

```shell
$ juliac --output-exe qdate --bundle build --trim=safe --experimental .
✓ Compiling...
 : ommitted the output

$ ./build/bin/qdate 今日 明日
今日 は、旧2025年09月14日、仏滅 です。
明日 は、旧2025年09月15日、大安 です。
```


## Requirements

+ [Julia](https://julialang.org) (VERSION ≥ v"1.10", ready for v"1.12")
    + QDates v0.0.2 is available for Julia of VERSION < v"0.6"
    + QDates v0.1.0 is available for Julia of VERSION < v"1.0"
    + QDates v0.3.0 is available for Julia of VERSION < v"1.10"
    + Julia of VERSION ≥ v"1.12" is required to install `qdate` CLI command.
+ Dates module


## Limitations

+ Year range is 445-2200. `QDate(2201)` throws `ArgumentError`.


## Credits

QDates.jl is created by @antimon2 (Shunsuke GOTOH).

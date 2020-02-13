QDates (Application Mode)
======

## Usage

```bash
$ build/bin/QDates -h
usage: QDates [-h] [date_like [date_like ...]]

Show Kyūreki (旧暦) or Gregorian date for the corresponding date.
Multiple `<date_like>` arguments may be specified, and displays all the results.
When no arguments are specified, show Kyūreki information of `今日` (today).

arguments:
  -h, --help            show this help message and exit
  <date_like>           Gregorian date (`yyyy-mm-dd`|`yyyy/mm/dd`) /
                        Kyūreki date (`旧yyyy年mm月dd日`|`旧yyyy年閏mm月dd日`) /
                        one of date_keywords ("今日"|"明日"|"明後日"|"明々後日"|"昨日"|"一昨日"|"一昨々日")

```

## Sample

```bash
$ build/bin/QDates
今日（2020-02-14）は旧2020年01月21日、先負です。

$ build/bin/QDates 今日 明日 明後日 明々後日 昨日 一昨日 一昨昨日 1976/01/10 2012-3-4 旧2020年1月1日 旧2017年閏5月1日 2222/1/1 旧2020年12月31日 無効な日付
今日は旧2020年01月21日です。
明日は旧2020年01月22日です。
明後日は旧2020年01月23日です。
明々後日は旧2020年01月24日です。
昨日は旧2020年01月20日です。
一昨日は旧2020年01月19日です。
一昨昨日は旧2020年01月18日です。
1976/01/10は旧1975年12月10日です。
2012-3-4は旧2012年02月12日です。
旧2020年1月1日は西暦2020-01-25です。
旧2017年閏5月1日は西暦2017-06-24です。
2222/1/1: 不正な日付、または対応範囲外の日付です。
旧2020年12月31日: 不正な日付、または対応範囲外の日付です。
無効な日付: 有効な日付として認識できません。

```

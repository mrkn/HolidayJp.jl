# HolidayJp

[![Build Status](https://github.com/mrkn/HolidayJp.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/mrkn/HolidayJp.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://coveralls.io/repos/github/mrkn/HolidayJp.jl/badge.svg?branch=main)](https://coveralls.io/github/mrkn/HolidayJp.jl?branch=main)

## Description

HolidayJp provides functions related to Japanese holidays for Julia language. This uses the Japanese holiday dataset in [holiday_jp/holiday_jp](https://github.com/holiday-jp/holiday_jp).

## Usage

```julia
import Dates: Date
import HolidadyJp

HolidayJP.isholiday(Date("2024-02-23"))  # true
HolidayJp.isholiday(2024, 12, 23)  # false

HolidayJp.getholiday(2024, 2, 23).name  # "天皇誕生日"
HolidayJp.getholiday(2024, 12, 23)  # nothing

[h.date for h in HolidayJp.between(Date("2024-01-01"), Date("2025-01-01"))]
# 21-element Vector{Date}:
#  2024-01-01
#  2024-01-08
#  ...
#  2024-11-23
```

## Installation

```
julia> ] add HolidayJp
```

## LICENSE

MIT

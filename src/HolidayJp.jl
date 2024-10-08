"""
    HolidayJp

The `HolidayJp` module provides features for detecting holiday in Japan.

```jldoctest
julia> using Dates

julia> HolidayJp.isholiday(Date(2018, 02, 23))
false

julia> HolidayJp.isholiday(Date(2018, 12, 23))
true

julia> HolidayJp.isholiday(Date(2019, 2, 23))
true

julia> HolidayJp.isholiday(Date(2019, 12, 23))
false
```
"""
module HolidayJp

import Dates: Date, DateTime, Day, year, month, day
import OrderedCollections: OrderedDict, rehash!
import YAML

"""
    HolidayJp.Holiday

`Holiday` represents a holiday in Japan.
"""
Base.@kwdef struct Holiday
    date::Date
    week::String
    week_en::String
    name::String
    name_en::String
end

function Holiday(params::AbstractDict)
    Holiday(date=Date(params["date"]),
            week=string(params["week"]),
            week_en=string(params["week_en"]),
            name=string(params["name"]),
            name_en=string(params["name_en"]))
end

const HolidayDict = OrderedDict{Date, Holiday}

function load_holidays()
    data_dir = joinpath(dirname(@__DIR__), "data")
    dataset = YAML.load_file(joinpath(data_dir, "holidays_detailed.yml"); dicttype=OrderedDict{Any, Any})
    HolidayDict(date => Holiday(params) for (date, params) in dataset)
end

const HOLIDAYS = load_holidays()

_datelike(d::Date) = d
_datelike(dl::T) where {T} = Date(year(dl), month(dl), day(dl))

"""
    isholiday(d) -> Bool
    isholiday(year, month, day) -> Bool

Return `true` if the given date is a holiday in Japan.

The date can be specified using a date-like object or by providing the year,
month, and day separately.
"""
isholiday(d::Date) = haskey(HOLIDAYS, d)
isholiday(year::I, month::I, day::I) where {I<:Integer} = isholiday(Date(year, month, day))
isholiday(dl::DateLike) where {DateLike} = isholiday(_datelike(dl))

"""
    getholiday(d) -> Union{Nothing,HolidayJp.Holiday}
    getholiday(year, month, day) -> Union{Nothing,HolidayJp.Holiday}

Return the holiday information for the given date.
When the given date is not a holiday in Japan, `nothing` is returned.

The date can be specified using a date-like object or by providing the year,
month, and day separately.
"""
getholiday(d::Date) = get(HOLIDAYS, d, nothing)
getholiday(year::I, month::I, day::I) where {I<:Integer} = getholiday(Date(year, month, day))
getholiday(dl::DateLike) where {DateLike} = getholiday(_datelike(dl))

"""
    between(lower_limit, upper_limit) -> Vector{HolidayJp.Holiday}

Return a vector of `HolidayJp.Holiday` objects that fall within the date range
defined by the `lower_limit` and the `upper_limit`.

The `lower_limit` and the `upper_limit` can be specified using a date-like objects.
"""
function between(lower_limit::Date, upper_limit::Date)
    if lower_limit > upper_limit
        error("lower_limit must be earlier than upper_limit (lower_limit=$(lower_limit), upper_limit=$(upper_limit))")
    end

    [h for h in values(HOLIDAYS) if lower_limit <= h.date <= upper_limit]
end

between(ll::LL, ul::UL) where {LL, UL} = between(_datelike(ll), _datelike(ul))

function __init__()
    rehash!(HOLIDAYS)
end

end

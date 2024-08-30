module HolidayJp

import Dates: Date, DateTime, Day, year, month, day
import OrderedCollections: OrderedDict
import YAML

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

const KeyType = NTuple{3, Int}
const HolidayDict = OrderedDict{KeyType, Holiday}
const HOLIDAYS = Ref{HolidayDict}()

_datelike(::Type{Date}, d::Date) = d
_datelike(::Type{Date}, dl::T) where {T} = Date(year(dl), month(dl), day(dl))

_datelike(::Type{KeyType}, dl::T) where {T} = (year(dl), month(dl), day(dl))

isholiday(key::KeyType) = haskey(HOLIDAYS[], key)
isholiday(year::I, month::I, day::I) where {I<:Integer} = isholiday((Int(year), Int(month), Int(day)))
isholiday(dl::DateLike) where {DateLike} = isholiday(_datelike(KeyType, dl)...)

getholiday(key::KeyType) = get(HOLIDAYS[], key, nothing)
getholiday(year::I, month::I, day::I) where {I<:Integer} = getholiday((Int(year), Int(month), Int(day)))
getholiday(dl::DateLike) where {DateLike} = getholiday(_datelike(KeyType, dl))

function between(lower_limit::Date, upper_limit::Date)
    if lower_limit > upper_limit
        error("lower_limit must be earlier than upper_limit (lower_limit=$(lower_limit), upper_limit=$(upper_limit))")
    end

    [h for h in values(HOLIDAYS[]) if lower_limit <= h.date <= upper_limit]
end

between(ll::LL, ul::UL) where {LL, UL} = between(_datelike(Date, ll), _datelike(Date, ul))

function __init__()
    data_dir = joinpath(dirname(@__DIR__), "data")
    dataset = YAML.load_file(joinpath(data_dir, "holidays_detailed.yml"); dicttype=OrderedDict{Any, Any})
    HOLIDAYS[] = OrderedDict((year(date), month(date), day(date)) => Holiday(params) for (date, params) in dataset)
end

end

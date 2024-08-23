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

isholiday(key::KeyType) = haskey(HOLIDAYS[], key)
isholiday(year::I, month::I, day::I) where {I<:Integer} = isholiday((Int(year), Int(month), Int(day)))
isholiday(x) = isholiday(year(x), month(x), day(x))

getholiday(key::KeyType) = get(HOLIDAYS[], key, nothing)
getholiday(year::I, month::I, day::I) where {I<:Integer} = getholiday((Int(year), Int(month), Int(day)))
getholiday(x) = getholiday(year(x), month(x), day(x))

function between(lower_limit::Date, upper_limit::Date)
    if lower_limit > upper_limit
        error("lower_limit must be earlier than upper_limit (lower_limit=$(lower_limit), upper_limit=$(upper_limit))")
    end

    [h for h in values(HOLIDAYS[]) if lower_limit <= h.date <= upper_limit]
end

function __init__()
    data_dir = joinpath(dirname(@__DIR__), "data")
    dataset = YAML.load_file(joinpath(data_dir, "holidays_detailed.yml"); dicttype=OrderedDict{Any, Any})
    HOLIDAYS[] = OrderedDict((year(date), month(date), day(date)) => Holiday(params) for (date, params) in dataset)
end

end

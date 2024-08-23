module HolidayJp

import Dates: Date, DateTime, year, month, day
import YAML

Base.@kwdef struct Holiday
    date
    week
    week_en
    name
    name_en
end

const KeyType = NTuple{3, Int}
const HolidayDict = Dict{KeyType, Holiday}
const HOLIDAYS = Ref{HolidayDict}()

isholiday(key::KeyType) = haskey(HOLIDAYS[], key)
isholiday(year::I, month::I, day::I) where {I<:Integer} = isholiday((Int(year), Int(month), Int(day)))
isholiday(x) = isholiday(year(x), month(x), day(x))

function __init__()
    data_dir = joinpath(dirname(@__DIR__), "data")
    dataset = YAML.load_file(joinpath(data_dir, "holidays_detailed.yml"))
    HOLIDAYS[] = Dict((year(date), month(date), day(date)) => Holiday(params...) for (date, params) in dataset)
end

end

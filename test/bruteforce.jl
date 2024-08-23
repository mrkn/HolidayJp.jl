module BruteForceTest

using Test

import HolidayJp: HolidayJp, YAML

data_dir = joinpath(dirname(@__DIR__), "data")
data = YAML.load_file(joinpath(data_dir, "holidays.yml"))

date_begin, date_end = extrema(keys(data))
for d in date_begin:date_end
    h = haskey(data, d)
    @testset "$(d) is$(h ? "" : " not") a holiday" begin
         @test HolidayJp.isholiday(d) === h
    end
end

end

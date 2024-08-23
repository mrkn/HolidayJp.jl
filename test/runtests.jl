module TestHolidayJp

using Test

import HolidayJp
import Dates: Dates, Date, DateTime

struct DateLike
    year
    month
    day
end

Dates.year(d::DateLike) = d.year
Dates.month(d::DateLike) = d.month
Dates.day(d::DateLike) = d.day

@testset "HolidayJp.jl" begin

    @testset "isholiday" begin
        @testset "when the given object is a Date" begin
            @test HolidayJp.isholiday(Date("2000-01-01")) === true
            @test HolidayJp.isholiday(Date("2000-01-02")) === false
        end

        @testset "when the given object is a DateTime" begin
            @test HolidayJp.isholiday(DateTime("2000-01-01", "yyyy-mm-dd")) === true
            @test HolidayJp.isholiday(DateTime("2000-01-02", "yyyy-mm-dd")) === false
        end

        @testset "when the given object responds to Dates.year, Dates.month, and Dates.day" begin
            @test HolidayJp.isholiday(DateLike(2000, 1, 1)) === true
            @test HolidayJp.isholiday(DateLike(2000, 1, 2)) === false
        end
    end

    @testset "between" begin
        @testset "returns all holidays when two Date objects are passed" begin
            result = HolidayJp.between(Date("2000-01-01"), Date("2000-12-31"))
            @test result isa Vector{HolidayJp.Holiday}
            @test [h.date::Date for h in result] == [
                Date("2000-01-01"),
                Date("2000-01-10"),
                Date("2000-02-11"),
                Date("2000-03-20"),
                Date("2000-04-29"),
                Date("2000-05-03"),
                Date("2000-05-04"),
                Date("2000-05-05"),
                Date("2000-07-20"),
                Date("2000-09-15"),
                Date("2000-09-23"),
                Date("2000-10-09"),
                Date("2000-11-03"),
                Date("2000-11-23"),
                Date("2000-12-23")
            ]
        end

        @testset "returns Holiday[] when the given range are out of scope" begin
            @test HolidayJp.Holiday[] == HolidayJp.between(Date("1900-01-01"), Date("1900-12-31"))

            year = Dates.year(Dates.today()) + 500
            @test HolidayJp.Holiday[] == HolidayJp.between(Date(year, 1, 1), Date(year, 12, 31))
        end

        @testset "raise error when the lower limit is future than the upper limit" begin
            @test_throws ErrorException HolidayJp.between(Date("2000-01-02"), Date("2000-01-01"))
        end
    end

end

end

include("bruteforce.jl")

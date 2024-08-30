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

        @testset "when the year, the month, and the day are specified separately" begin
            @test HolidayJp.isholiday(2000, 1, 1) === true
            @test HolidayJp.isholiday(2000, 1, 2) === false
        end
    end

    @testset "getholiday" begin
        @testset "returns a Holiday when the given date is a holiday" begin
            @test HolidayJp.getholiday(Date("2000-01-01")) isa HolidayJp.Holiday
            @test HolidayJp.getholiday(DateTime("2000-01-01", "yyyy-mm-dd")) isa HolidayJp.Holiday
            @test HolidayJp.getholiday(DateLike(2000, 1, 1)) isa HolidayJp.Holiday
            @test HolidayJp.getholiday(2000, 1, 1) isa HolidayJp.Holiday
        end

        @testset "returns nothing when the given Date is not a holiday" begin
            @test HolidayJp.getholiday(Date("2000-01-02")) === nothing
            @test HolidayJp.getholiday(DateTime("2000-01-02", "yyyy-mm-dd")) === nothing
            @test HolidayJp.getholiday(DateLike(2000, 1, 2)) === nothing
            @test HolidayJp.getholiday(2000, 1, 2) === nothing
        end
    end

    @testset "between" begin
        expected = [
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

        @testset "returns all holidays when two Date objects are passed" begin
            result = HolidayJp.between(Date("2000-01-01"), Date("2000-12-31"))
            @test result isa Vector{HolidayJp.Holiday}
            @test [h.date::Date for h in result] == expected
        end

        @testset "accepts date-like objects as its arguments" begin
            result = HolidayJp.between(Date(2000, 1, 1), DateLike(2000, 12, 31))
            @test [h.date::Date for h in result] == expected

            result = HolidayJp.between(DateLike(2000, 1, 1), Date(2000, 12, 31))
            @test [h.date::Date for h in result] == expected

            result = HolidayJp.between(DateLike(2000, 1, 1), DateLike(2000, 12, 31))
            @test [h.date::Date for h in result] == expected
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

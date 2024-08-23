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
end

end

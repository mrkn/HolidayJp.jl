module HolidayJp

import Dates: Date, DateTime, year, month, day

function isholiday(year::I, month::I, day::I) where {I<:Integer}
    (year, month, day) == (2000, 1, 1)
end

isholiday(x) = isholiday(year(x), month(x), day(x))

end

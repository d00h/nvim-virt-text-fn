
local SECONDS_IN_A_DAY = 60 * 60 * 24
local t1 = os.time({ year = 1970, month = 1, day = 1, hour = 0 })
local t2 = os.time({ year = 1970, month = 1, day = 10, hour = 0 })

print(os.difftime(t2, t1) / SECONDS_IN_A_DAY)


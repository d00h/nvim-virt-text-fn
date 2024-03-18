local parsers = require("nvim-virt-text-fn.parsers")

local function timedelta(selector)
  return function(bufnr, row)
    local SECONDS_IN_A_DAY = 60 * 60 * 24
    local now = os.time(os.date("*t"))
    for _, text in ipairs(selector(bufnr, row)) do
      for found in parsers.parse_datetime(text) do
        return string.format("%d days", os.difftime(now, found) / SECONDS_IN_A_DAY)
      end
    end
    return "???"
  end
end

local function count_todo(selector)
  return function(bufnr, row)
    local pattern = "^- %[([%sx])%]"
    local total, done = 0, 0
    for _, text in ipairs(selector(bufnr, row)) do
      for found in parsers.parse_todo(text) do
        total = total + 1
        if found == "x" then
          done = done + 1
        end
      end
    end
    if total == 0 then
      return "???"
    else
      return string.format("%d of %d", done, total)
    end
  end
end

return {
  timedelta = timedelta,
  count_todo = count_todo,
}

local parsers = require("nvim-virt-text-calc.parsers")
local selectors = require("nvim-virt-text-calc.selectors")

local function timedelta(lines)
  local SECONDS_IN_A_DAY = 60 * 60 * 24
  local now = os.time(os.date("*t"))
  for _, text in ipairs(lines) do
    for found in parsers.parse_datetime(text) do
      return string.format("%d days", os.difftime(now, found) / SECONDS_IN_A_DAY)
    end
  end
  return "???"
end

local function count_todo(lines)
  local pattern = "^- %[([%sx])%]"
  local total, done = 0, 0
  for _, text in ipairs(lines) do
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

local function percent_todo(lines)
  local pattern = "^- %[([%sx])%]"
  local total, done = 0, 0
  for _, text in ipairs(lines) do
    for found in parsers.parse_todo(text) do
      total = total + 1
      if found == "x" then
        done = done + 1
      end
    end
  end
  if total == 0 then
    return "0%"
  else
    return string.format("%d%%", done * 100 / total)
  end
end

local function sum_integers(lines)
  local result = 0
  for _, text in ipairs(lines) do
    for value in parsers.parse_integers(text) do
      result = result + value
    end
  end
  return tostring(result)
end

local function wrap(fn, selector)
  return function(args)
    return function(bufnr, row)
      local lines = selector(bufnr, row)
      return fn(lines)
    end
  end
end

return {
  timedelta = wrap(timedelta, selectors.current_line),
  count_todo = wrap(count_todo, selectors.current_section),
  percent_todo = wrap(percent_todo, selectors.current_section),
  sum = wrap(sum_integers, selectors.current_section),
}

--- found all like =sum(paragraph)
local function parse_functions(text)
  local last_pos = 0
  local pattern = "=(%a[%a%d_]*)%(([^%)]*)%)"
  return function()
    if last_pos >= #text then
      return
    end
    local found_start, found_end, found_name, found_args = string.find(text, pattern, last_pos)
    if found_start == nil then
      last_pos = #text
      return
    else
      local args = {}
      for word in string.gmatch(found_args, "[^%,]+") do
        table.insert(args, word)
      end
      last_pos = found_end or #text
      return {
        ["name"] = found_name,
        ["args"] = args,
        range = { ["start"] = found_start, ["end"] = found_end },
      }
    end
  end
end

local function parse_functions_in_viewpoint(win)
  local first_line = vim.fn.line("w0", win) - 1
  local last_line = vim.fn.line("w$", win)
  local bufnr = vim.api.nvim_win_get_buf(win)

  local lines = vim.api.nvim_buf_get_lines(bufnr, first_line, last_line, false)
  local result = {}
  for delta, text in ipairs(lines) do
    for fn in parse_functions(text) do
      table.insert(result, { line = first_line + delta - 1, name = fn.name, args = fn.args })
    end
  end
  return result
end

local function parse_datetime(text)
  local pattern = "(%d+)-(%d+)-(%d+)"
  local last_pos = 0
  return function()
    if last_pos >= #text then
      return nil
    end

    local found_start, found_end, value1, value2, value3 = string.find(text, pattern, last_pos)
    if found_start == nil then
      last_pos = #text
      return nil
    end
    last_pos = found_end

    value1, value2, value3 = tonumber(value1), tonumber(value2), tonumber(value3)
    if value1 >= 1 and value1 <= 31 and value2 >= 1 and value2 <= 12 and value3 >= 1970 then
      local args = { year = value3, month = value2, day = value1 }
      local success, ret = pcall(os.time, args)
      if success then
        return ret
      end
    end

    if value3 >= 1 and value3 <= 31 and value2 >= 1 and value2 <= 12 and value1 >= 1970 then
      local args = { year = value1, month = value2, day = value3 }
      local success, ret = pcall(os.time, args)
      if success then
        return ret
      end
    end

    return nil
  end
end

local function parse_todo(text)
  local pattern = "^- %[(.)%]%s+"
  local last_pos = 0
  return function()
    local found_start, found_end, value = string.find(text, pattern, last_pos)
    if found_start == nil then
      last_pos = #text
      return nil
    end
    last_pos = found_end
    return value
  end
end

return {
  parse_functions = parse_functions,
  parse_functions_in_viewpoint = parse_functions_in_viewpoint,
  parse_datetime = parse_datetime,
  parse_todo = parse_todo,
}

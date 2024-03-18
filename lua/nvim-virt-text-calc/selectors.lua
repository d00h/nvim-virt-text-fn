local function find_current_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
end

local function find_section(bufnr, row)
  local count = vim.api.nvim_buf_line_count(bufnr)

  local start_row = row
  while start_row > 0 do
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)
    local match = string.match("^([%#]+)%s+", lines[1])
    if match then
      break
    end
    start_row = start_row - 1
  end

  local end_row = row + 1
  while end_row < count do
    local lines = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)
    local match = string.match("^([%#]+)%s+", lines[1])
    if match then
      break
    end
    end_row = end_row + 1
  end
  return vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)
end

local function find_visual_lines(bufnr, row)
  local _, ls, _ = unpack(vim.fn.getpos("v"))
  local _, le, _ = unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_lines(bufnr, ls - 1, le - 1, false)
end

local function find_paragraph(bufnr, row)
  local function is_empty(line)
    local lines = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)
    local text = string.gsub(lines[1] or "", "%s+", "")
    return text == ""
  end

  local function get_start_line()
    local line = row
    while not is_empty(line - 1) do
      line = line - 1
    end
    return line
  end

  local function get_end_line()
    local line = row
    while not is_empty(line) do
      line = line + 1
    end
    return line
  end
  return vim.api.nvim_buf_get_lines(bufnr, get_start_line(), get_end_line(), false)
end

local function find_buffer_text(bufnr, row)
  local start_line = 0
  local end_line = vim.api.nvim_buf_line_count(bufnr)
  return vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
end

return {
  visual = find_visual_lines,
  current_line = find_current_line,
  current_buffer = find_buffer_text,
  current_paragraph = find_paragraph,
  current_section = find_section,
}

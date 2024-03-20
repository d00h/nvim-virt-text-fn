local function index_prev_pattern(pattern, bufnr, row)
  local count = vim.api.nvim_buf_line_count(bufnr)

  while row >= 0 and row < count do
    local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
    local match = string.match(lines[1], pattern)
    if match then
      return row
    end
    row = row - 1
  end
end

local function index_next_pattern(pattern, bufnr, row)
  local count = vim.api.nvim_buf_line_count(bufnr)

  while row >= 0 and row < count do
    local lines = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
    local match = string.match(lines[1], pattern)
    if match then
      return row
    end
    row = row + 1
  end
end

local function find_current_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
end

local function find_section(bufnr, row)
  local pattern = "^([%#]+)%s+"
  local start_row = index_prev_pattern(pattern, bufnr, row) or 0
  local end_row = index_next_pattern(pattern, bufnr, start_row + 1)
    or vim.api.nvim_buf_line_count(bufnr)

  print(start_row, end_row)

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

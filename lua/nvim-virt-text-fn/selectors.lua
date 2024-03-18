local function find_current_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)
end

local function paragraph_above(bufnr, row)
  return {}
end

local function paragraph_below(bufnr, row)
  return {}
end

local function find_visual_lines()
  local _, ls, _ = unpack(vim.fn.getpos("v"))
  local _, le, _ = unpack(vim.fn.getpos("."))
  return vim.api.nvim_buf_get_lines(0, ls - 1, le - 1, false)
end

local function find_current_paragraph(bufnr, row)
  local function is_empty(line)
    local lines = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)
    local text = string.gsub(lines[1] or "", "%s+", "")
    return text == ""
  end

  local function get_start_line()
    local start_line = vim.fn.line(".")
    while not is_empty(start_line - 1) do
      start_line = start_line - 1
    end
    return start_line
  end

  local function get_end_line()
    local line = vim.fn.line(".")
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
}

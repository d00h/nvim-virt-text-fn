local parsers = require("nvim-virt-text-calc.parsers")
local buildins = require("nvim-virt-text-calc.buildins")
local render = require("nvim-virt-text-calc.render")

local DEFAULT_MAPPING_CONFIG = {
  timedelta = buildins.timedelta,
  count_todo = buildins.count_todo,
  percent_todo = buildins.percent_todo,
}
local DEFAULT_RENDER_CONFIG = {
  namespace = "virt-text-calc",
  virt_text_pos = "eol",
  virt_text_highlight = "Todo",
}

local function echo(message, highlight)
  vim.api.nvim_echo({ { message, highlight } }, true, {})
end

local function create_virt_text_callback(opts)
  local mapping_config = vim.tbl_extend("keep", opts.mapping or {}, DEFAULT_MAPPING_CONFIG)
  local render_config = vim.tbl_extend("keep", opts.render or {}, DEFAULT_RENDER_CONFIG)
  local render = render.create_render(render_config)

  local function execute(found)
    local fn = mapping_config[found.name]
    if fn == nil then
      return string.format("unknown function '%s'", found.name)
    end

    local success, ret = pcall(fn, found.args)
    if not success then
      return ret
    end

    local handler = ret
    local _, ret = pcall(handler, found.bufnr, found.line)
    return ret
  end

  return function(input)
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    vim.schedule(function()
      local items = {}
      for _, found in ipairs(parsers.parse_functions_in_viewpoint(win)) do
        local text = execute(found)
        table.insert(items, { text = text, line = found.line })
      end
      render(bufnr, items)
    end)
  end
end

local function setup(opts)
  local virt_text_callback = create_virt_text_callback(opts)
  local filetypes = opts.filetypes or { "markdown" }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetypes,
    callback = function(input)
      local augroup = vim.api.nvim_create_augroup("VIRT_TEXT_CALC", { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        buffer = input.bufnr,
        callback = virt_text_callback,
        group = "VIRT_TEXT_CALC",
      })
    end,
  })
end

return {
  setup = setup,
  create_virt_text_callback = create_virt_text_callback,
}

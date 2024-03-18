local parsers = require("nvim-virt-text-fn.parsers")
local selectors = require("nvim-virt-text-fn.selectors")
local buildins = require("nvim-virt-text-fn.buildins")
local render = require("nvim-virt-text-fn.render")

local DEFAULT_MAPPING_CONFIG = {
  timedelta = buildins.timedelta(selectors.current_line),
  count_todo = buildins.count_todo(selectors.current_buffer),
}
local DEFAULT_RENDER_CONFIG = {
  namespace = "virt-text-fn",
  virt_text_pos = "eol",
  virt_text_highlight = "Todo",
}

local function create_virt_text_callback(opts)
  local mapping_config = opts.mapping or DEFAULT_MAPPING_CONFIG
  local render_config = vim.tbl_extend("keep", opts.render or {}, DEFAULT_RENDER_CONFIG)
  local render = render.create_render(render_config)

  return function()
    local items = {}
    local win = vim.api.nvim_get_current_win()
    local bufnr = vim.api.nvim_win_get_buf(win)
    for _, fn in ipairs(parsers.parse_functions_in_viewpoint(win)) do
      local handler = mapping_config[fn.name]

      local _, ret = pcall(handler, bufnr, fn.line)
      table.insert(items, { text = ret, line = fn.line })
    end
    render(bufnr, items)
  end
end

local function setup(opts)
  local virt_text_callback = create_virt_text_callback(opts)
  vim.api.nvim_create_autocmd("CursorHold", { callback = virt_text_callback })
end

return {
  setup = setup,
  create_virt_text_callback = create_virt_text_callback,
}

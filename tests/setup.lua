--
if not string.find(package.path, vim.fn.getcwd()) then
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?/init.lua"
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?.lua"
end

-- =calc()
package.loaded["nvim-virt-text-calc.parsers"] = nil
package.loaded["nvim-virt-text-calc.buildins"] = nil
package.loaded["nvim-virt-text-calc.selectors"] = nil
package.loaded["nvim-virt-text-calc.render"] = nil

local parsers = require("nvim-virt-text-calc.parsers")
local selectors = require("nvim-virt-text-calc.selectors")
local buildins = require("nvim-virt-text-calc.buildins")
local render = require("nvim-virt-text-calc.render")

local mapping = {
  timedelta = buildins.timedelta(selectors.current_line),
  count_todo = buildins.count_todo(selectors.current_buffer),
}

local render = render.create_render({
  namespace = "vir-text-calc",
  virt_text_pos = "eol",
  virt_text_highlight = "Todo",
})

local function callback_virt_text()
  local items = {}
  local win = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(win)
  for _, fn in ipairs(parsers.parse_functions_in_viewpoint(win)) do
    local handler = mapping[fn.name]

    local _, ret = pcall(handler, bufnr, fn.line)
    table.insert(items, { text = ret, line = fn.line })
  end
  render(bufnr, items)
end

vim.api.nvim_create_autocmd("CursorHold", { callback = callback_virt_text })


--[[
Задач =count_todo()
- [x] fdfd
- [ ] dsds 


-- ездили в Турцию 5-01-2024 =timedelta()
-- 3
--]]

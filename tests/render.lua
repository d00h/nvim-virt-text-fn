if not string.find(package.path, vim.fn.getcwd()) then
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?/init.lua"
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?.lua"
end

package.loaded["nvim-virt-text-fn.render"] = nil

local create_render = require("nvim-virt-text-fn.render").create_render

local items = {
  { text = "hello10", line = 10 },
  { text = "hello20", line = 19 },
}

local bufnr = vim.api.nvim_get_current_buf()
local render = create_render({
  namespace = "lsp-diagnostics",
  virt_text_pos = "eol",
  virt_text_highlight = "Todo",
})

render(bufnr, items)

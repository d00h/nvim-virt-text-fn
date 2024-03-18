
if not string.find(package.path, vim.fn.getcwd()) then
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?/init.lua"
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?.lua"
end

package.loaded["nvim-virt-text-calc.selectors"] = nil

local selectors = require("nvim-virt-text-calc.selectors")

vim.cmd("messages clear")

for _, line in ipairs(selectors.current_section(0, 13)) do
  print(line)
end

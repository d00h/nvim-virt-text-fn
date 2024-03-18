if not string.find(package.path, vim.fn.getcwd()) then
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?/init.lua"
  package.path = package.path .. ";" .. vim.fn.getcwd() .. "/lua/?.lua"
end

package.loaded["nvim-virt-text-fn.parser"] = nil

local parse_functions = require("nvim-virt-text-fn.parser").parse_functions

vim.cmd("messages clear")

local text = "fdfd  =sum(2121) "

for found in parse_functions(text) do
  print(vim.inspect(found))
end


# Summary 

An attempt to make something more useful out of the mechanism of virtual text.

At the moment, apart from displaying diagnostic messages, I have not found any use cases, but there is an idea that something can be calculated on the fly based on the text.

```markdown
2+2 =sum() 4
```


# Installation 

```lua
plugin.register({
    url = "d00h/nvim-virt-text-calc",
    config = function()
        require("nvim-virt-text-calc").setup({})
    end
})
```

Or a bit more complex:

```lua
local function proba_calc(args)
   return function(bufnr, row)
       return "42"
   end
end

plugin.register({
    url = "d00h/nvim-virt-text-calc",
    config = function()
        local buildins =  require("nvim-virt-text-calc.buildins")
        
        require("nvim-virt-text-calc").setup({
          filetypes = { "markdown" },
          mapping = {
              -- list of functions
              timedelta = buildins.timedelta,
              count_todo = buildins.count_todo,
              percent_todo = buildins.percent_todo,
              proba = proba_calc, -- you can write =proba()
          },
          render = {
              -- parameters of vim.api.nvim_buf_set_extmark
              namespace = "virt-text-calc",
              virt_text_pos = "eol",
              virt_text_highlight = "Todo",
          },
        })
    end
})
```

# Principle 

1. Find something similar to =func() in the text.
2. Look for the name func in mapping.
3. If it exists, execute it and display the result in virtual text.

# Buildin functions

| function     | action                              | sample                           |
|--------------|-------------------------------------|----------------------------------|
| timedelta    | count days to now                   | 24-02-2022 =timedelta() 754 days |
| count_todo   | count markdown todos in the section | =count_todo() 1 of 2             |
| percent_todo |                                     | =percent_todo()  50%             |
| sum          | sum all integers in the section     | 1 2 =sum()  2                    |

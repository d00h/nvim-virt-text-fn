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
local function proba_calc(bufnr, row)
   return "42"
end

plugin.register({
    url = "d00h/nvim-virt-text-calc",
    config = function()
        local buildins =  require("nvim-virt-text-calc.buildins")
        local selectors =  require("nvim-virt-text-calc.selectors")
        
        require("nvim-virt-text-calc").setup({
          filetypes = { "markdown" },
          mapping = {
              timedelta = buildins.timedelta(selectors.current_line),
              count_todo = buildins.count_todo(selectors.current_paragraph),
              percent_todo = buildins.percent_todo(selectors.current_paragraph),
              proba = proba_calc, -- you can write =proba() 
          },
          render = {
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


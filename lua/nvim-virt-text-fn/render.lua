local function create_render(opts)
  local namespace = opts.namespace or "nvim-virt-text-fn"
  local virt_text_pos = opts.virt_text_pos or "eol"
  local virt_text_highlight = opts.virt_text_highlight or "Error"

  return function(bufnr, items)
    local ns_id = vim.api.nvim_create_namespace(namespace)
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
    for id, item in ipairs(items) do
      local opts = {
        id = id,
        virt_text = { { item.text, virt_text_highlight } },
        virt_text_pos = virt_text_pos,
      }
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, item.line, item.col or 0, opts)
    end
  end
end

return {
  create_render = create_render,
}

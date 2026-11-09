vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

vim.lsp.enable({ "emmylua_ls" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function (args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = args.buf, desc = "Show diagnostics" })

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "grd", vim.lsp.buf.definition, { buffer = args.buf, desc = "Go to definition" })
    end

    if client:supports_method("textDocument/hover") then
      vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { buffer = args.buf, desc = "Show hover documentation" })
    end

    if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
        buffer = args.buf,
        callback = function ()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end
      })
    end
  end
})

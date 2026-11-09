---@type vim.lsp.Config
return {
  settings = {
    emmylua = {
      runtime = {
        version = "LuaJIT"
      },
      workspace = {
        library = {
          vim.fn.stdpath("config"),
          vim.env.VIMRUNTIME
        }
      }
    }
  }
}

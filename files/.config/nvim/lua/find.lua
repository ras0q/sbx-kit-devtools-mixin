local files
local group = vim.api.nvim_create_augroup("VanillaFind", { clear = true })

require("live_qf").setup({
  name = "Find",
  nargs = "*",
  efm = "%f",
  search = function(query, done)
    local function filter()
      done(query == "" and files or vim.fn.matchfuzzy(files, query))
    end
    if files then
      filter()
      return
    end
    local process = vim.system({
      "rg", "--files", "--hidden", "-g", "!.git",
    }, { text = true }, function(result)
      vim.schedule(function()
        if result.code ~= 0 and result.code ~= 1 then
          done({}, result.stderr)
          return
        end
        files = vim.split(result.stdout or "", "\n", { trimempty = true })
        filter()
      end)
    end)
    return function()
      process:kill(15)
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  pattern = ":",
  callback = function()
    files = nil
  end,
})

vim.keymap.set("n", "<leader>ff", ":Find ", { desc = "Find files" })

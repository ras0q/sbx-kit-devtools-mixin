require("live_qf").setup({
  name = "Grep",
  min_length = 2,
  search = function(query, done)
    local process = vim.system({
      "rg", "--vimgrep", "--color=never", "--smart-case",
      "--hidden", "-g", "!.git", "--", query,
    }, { text = true }, function(result)
      if result.code ~= 0 and result.code ~= 1 then
        done({}, result.stderr)
      else
        done(vim.split(result.stdout or "", "\n", { trimempty = true }))
      end
    end)
    return function()
      process:kill(15)
    end
  end,
})

vim.keymap.set("n", "<leader>fg", ":Grep ", { desc = "Grep files" })

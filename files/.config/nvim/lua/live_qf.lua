local M = {}
local commands = {}

-- search(query, done) returns a cancellation function; done receives quickfix lines and an optional error.
function M.setup(opts)
  commands[opts.name] = true
  local group = vim.api.nvim_create_augroup("LiveQuickfix" .. opts.name, { clear = true })
  local generation = 0
  local stop_search
  local displayed_query
  local displayed_id

  local function cancel()
    generation = generation + 1
    if stop_search then
      stop_search()
      stop_search = nil
    end
  end

  local function show(query, lines, focus)
    local win = vim.api.nvim_get_current_win()
    vim.fn.setqflist({}, "r", {
      title = opts.name .. ": " .. query,
      lines = lines,
      efm = opts.efm or "%f:%l:%c:%m",
    })
    displayed_query = query
    displayed_id = vim.fn.getqflist({ id = 0 }).id
    vim.cmd("botright copen 10")
    vim.wo.cursorline = true
    if not focus and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_current_win(win)
    end
    vim.cmd("redraw")
  end

  local function search(query, focus)
    cancel()
    local current = generation
    if #query < (opts.min_length or 0) then
      show(query, {}, focus)
      return
    end
    local function run()
      if current ~= generation then
        return
      end
      stop_search = opts.search(query, function(lines, err)
        vim.schedule(function()
          if current ~= generation then
            return
          end
          stop_search = nil
          show(query, lines or {}, focus)
          if err then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end)
      end)
    end
    if focus then
      run()
    else
      vim.defer_fn(run, opts.debounce or 120)
    end
  end

  vim.api.nvim_create_user_command(opts.name, function(args)
    if args.args == displayed_query and displayed_id == vim.fn.getqflist({ id = 0 }).id then
      cancel()
      vim.cmd("botright copen 10")
    else
      search(args.args, true)
    end
  end, { nargs = opts.nargs or "+" })

  vim.api.nvim_create_autocmd("CmdlineEnter", {
    group = group,
    pattern = ":",
    callback = function()
      cancel()
      displayed_query = nil
      displayed_id = nil
    end,
  })

  vim.api.nvim_create_autocmd("CmdlineChanged", {
    group = group,
    pattern = ":",
    callback = function()
      local query = vim.fn.getcmdline():match("^" .. opts.name .. "%s+(.*)$")
      if query then
        search(query, false)
      else
        cancel()
      end
    end,
  })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    pattern = ":",
    callback = cancel,
  })
end

-- Move the selection without leaving the search prompt.
for key, direction in pairs({ ["<C-j>"] = 1, ["<C-k>"] = -1 }) do
  vim.keymap.set("c", key, function()
    local command = vim.fn.getcmdline():match("^(%u%w*)%s")
    if vim.fn.getcmdtype() ~= ":" or not commands[command] then
      return key
    end
    vim.schedule(function()
      local win = vim.fn.getqflist({ winid = 0 }).winid
      if win ~= 0 and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_call(win, function()
          local row = vim.api.nvim_win_get_cursor(win)[1]
          local count = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(win))
          row = math.max(1, math.min(count, row + direction))
          vim.api.nvim_win_set_cursor(win, { row, 0 })
          vim.fn.setqflist({}, "a", { idx = row })
          vim.cmd("normal! zv")
        end)
        vim.cmd("redraw")
      end
    end)
    return "<Ignore>"
  end, { expr = true, desc = "Select live quickfix result" })
end

return M

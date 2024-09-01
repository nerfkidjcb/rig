-- Enable line numbers
vim.opt.number = true

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- A <Tab> counts as 3 spaces
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3

-- Set the leader key to be `Space`
vim.g.mapleader = ' '

-- Move left and right between windows using `Leader + h` and `Leader + l`
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', { noremap = true, silent = true })

-- Move the selected window left (if not at the leftmost window) when pressing `Leader + Shift + h`
function MoveWindowLeft()
    local current_win = vim.api.nvim_get_current_win()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local wins = vim.api.nvim_tabpage_list_wins(current_tab)

    local current_win_index = nil
    for i, win in ipairs(wins) do
        if win == current_win then
            current_win_index = i
            break
        end
    end

    -- If the current window is the leftmost one, do nothing.
    if current_win_index == 1 then
        return
    end

    -- Otherwise, swap the current window with the one to its left.
    local target_win = wins[current_win_index - 1]

    -- Get buffers associated with the windows
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local target_buf = vim.api.nvim_win_get_buf(target_win)

    -- Swap the buffers between the two windows
    vim.api.nvim_win_set_buf(current_win, target_buf)
    vim.api.nvim_win_set_buf(target_win, current_buf)

    -- Maintain cursor position
    local current_cursor = vim.api.nvim_win_get_cursor(current_win)
    vim.api.nvim_win_set_cursor(target_win, current_cursor)

    -- Move the cursor to the new window
    vim.api.nvim_set_current_win(target_win)
end
vim.api.nvim_set_keymap('n', '<Leader><S-h>', ':lua MoveWindowLeft()<CR>', { noremap = true, silent = true })

-- Move the selected window right (if not at the rightmost window) when pressing `Leader + Shift + l`
function MoveWindowRight()
    local current_win = vim.api.nvim_get_current_win()
    local current_tab = vim.api.nvim_get_current_tabpage()
    local wins = vim.api.nvim_tabpage_list_wins(current_tab)

    local current_win_index = nil
    for i, win in ipairs(wins) do
        if win == current_win then
            current_win_index = i
            break
        end
    end

    -- If the current window is the rightmost one, do nothing.
    if current_win_index == #wins then
        return
    end

    -- Otherwise, swap the current window with the one to its right.
    local target_win = wins[current_win_index + 1]

    -- Get buffers associated with the windows
    local current_buf = vim.api.nvim_win_get_buf(current_win)
    local target_buf = vim.api.nvim_win_get_buf(target_win)

    -- Swap the buffers between the two windows
    vim.api.nvim_win_set_buf(current_win, target_buf)
    vim.api.nvim_win_set_buf(target_win, current_buf)

    -- Maintain cursor position
    local current_cursor = vim.api.nvim_win_get_cursor(current_win)
    vim.api.nvim_win_set_cursor(target_win, current_cursor)

    -- Move the cursor to the new window
    vim.api.nvim_set_current_win(target_win)
end
vim.api.nvim_set_keymap('n', '<Leader><S-l>', ':lua MoveWindowRight()<CR>', { noremap = true, silent = true })

-- If Lazy (package manager) has not been cloned, clone it
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- Setup Lazy to load plugins from each of the individual lua/plugins/<plugin>.lua files
require("lazy").setup("plugins")



------------------------------------------------------------------
--- TEMP: All of the below is to be moved to plugins directory ---
------------------------------------------------------------------

-- Setup None (a fork of null-ls) for linting and formatting
local null_ls = require("null-ls")
null_ls.setup({
   sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.isort,
   },
})
vim.keymap.set("n", "<C-h>", vim.lsp.buf.format, {})

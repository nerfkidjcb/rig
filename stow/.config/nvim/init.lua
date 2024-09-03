-- Enable line numbers
vim.opt.number = true

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- A <Tab> counts as 3 spaces
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.shiftwidth = 3

-- Move left and right between windows using `Ctrl + h` and `Ctrl + l`
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Move the selected window left (if not at the leftmost window) when pressing `Ctrl + Shift + h`
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

vim.api.nvim_set_keymap("n", "<C-S-h>", ":lua MoveWindowLeft()<CR>", { noremap = true, silent = true })

-- Move the selected window right (if not at the rightmost window) when pressing `Ctrl + Shift + l`
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

vim.api.nvim_set_keymap("n", "<C-S-l>", ":lua MoveWindowRight()<CR>", { noremap = true, silent = true })

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

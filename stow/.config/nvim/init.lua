-- Setup basic Vim config
vim.cmd("set expandtab")
vim.cmd("set tabstop=3")
vim.cmd("set softtabstop=3")
vim.cmd("set shiftwidth=3")

vim.opt.number = true -- Enable line numbers

-- Install Lazy package manager
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
-- Install packages with Lazy
local plugins = {
   {
      "projekt0n/github-nvim-theme",
      lazy = false,
      priority = 1000,
   },
   { "nvim-treesitter/nvim-treesitter",        build = ":TSUpdate" },
   {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = { "nvim-lua/plenary.nvim" },
   },
   {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
   },
   { "nvim-telescope/telescope-ui-select.nvim" },
   { "williamboman/mason.nvim" },
   { "williamboman/mason-lspconfig.nvim" },
   { "neovim/nvim-lspconfig" },
   { "nvimtools/none-ls.nvim" },
   { "github/copilot.vim" },
   { 'akinsho/toggleterm.nvim', },
   {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true },
      config = function()
         require('lualine').setup {
            options = {
               theme = 'bubble',
               component_separators = { left = '', right = '' },
               section_separators = { left = '', right = '' },
            },
            sections = {
               lualine_a = { 'mode' },
               lualine_b = { 'branch', 'diff', 'diagnostics' },
               lualine_c = { 'filename' },
               lualine_x = { 'encoding', 'fileformat', 'filetype' },
               lualine_y = { 'progress' },
               lualine_z = { 'location' }
            },
            inactive_sections = {
               lualine_a = {},
               lualine_b = {},
               lualine_c = { 'filename' },
               lualine_x = { 'location' },
               lualine_y = {},
               lualine_z = {}
            },
            tabline = {},
            extensions = {}
         }
      end
   }

}
local opts = {}
require("lazy").setup(plugins, opts)
-- Setup colors using GitHub Dark Default theme
require("github-theme").setup()
vim.cmd("colorscheme github_dark_default")

-- Setup tree parser with Treesitter
local treesitter = require("nvim-treesitter.configs")
treesitter.setup({
   auto_install = true,
   highlight = { enable = true },
   indent = { enable = true },
})
-- Setup fuzzy file, grep finder, and file explorer with Telescope
vim.keymap.set("n", "<C-d>", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>")
vim.keymap.set("n", "<C-f>", ":Telescope find_files hidden=true<CR>")
vim.keymap.set("n", "<C-g>", ":Telescope live_grep hidden=true<CR>")
local telescope = require("telescope")
telescope.load_extension("ui-select")
local actions = require('telescope.actions')
telescope.setup({
   defaults = {
      mappings = {
         i = {
            ["<C-x>"] = actions.select_vertical, -- Open vertically, but change window placement
         },
         n = {
            ["<C-x>"] = actions.select_vertical, -- Same for normal mode
         },
      },
   },
})
-- Setup LSP using Mason
local mason = require("mason")
mason.setup()
local mason_lsp_config = require("mason-lspconfig")
mason_lsp_config.setup({
   ensure_installed = { "lua_ls", "biome", "cssls", "eslint", "intelephense" },
})
local lsp_config = require("lspconfig")
lsp_config.lua_ls.setup({
   handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
         virtual_text = true,
         signs = true,
         update_in_insert = true,
      }),
   },
})
lsp_config.biome.setup({})
lsp_config.cssls.setup({})
lsp_config.eslint.setup({})
lsp_config.intelephense.setup({})
vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<C-j>", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<C-l>", vim.lsp.buf.code_action, {})
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

vim.o.splitright = false
vim.o.splitbelow = false

-- Key mappings for window navigation (Cmd + Arrow keys) in normal mode
vim.api.nvim_set_keymap('n', '<D-Left>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<D-Right>', '<C-w>l', { noremap = true, silent = true })

-- Swap with window to the left
vim.keymap.set('n', '<M-Left>', function()
    vim.cmd('wincmd h')
    vim.cmd('wincmd x')
end, { silent = true })

-- Swap with window to the right
vim.keymap.set('n', '<M-Right>', '<C-w>x<C-w>l', { silent = true })

local toggleterm = require("toggleterm")
toggleterm.setup({
   size = function(term)
      if term.direction == "horizontal" then
         return 15
      elseif term.direction == "vertical" then
         return vim.o.columns * 0.4
      end
   end,
   open_mapping = [[<C-t>]],
   hide_numbers = true,
   shade_filetypes = {},
   shade_terminals = true,
   start_in_insert = true,
   insert_mappings = true,
   persist_size = true,
   direction = 'float',
   close_on_exit = true,
   shell = vim.o.shell,
   float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
         border = "Normal",
         background = "Normal",
      },
   },
})

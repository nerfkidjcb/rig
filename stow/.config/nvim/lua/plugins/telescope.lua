return {
   {
      "nvim-telescope/telescope-ui-select.nvim"
   },
   {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.6",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         local telescope = require("telescope")
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
         telescope.load_extension("ui-select")
      end
   },
   {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      config = function()
         vim.keymap.set("n", "<leader>d", ":Telescope file_browser path=%:p:h select_buffer=true hidden=true<CR>")
         vim.keymap.set("n", "<leader>f", ":Telescope find_files hidden=true<CR>")
         vim.keymap.set("n", "<leader>g", ":Telescope live_grep hidden=true<CR>")
      end
   },
}

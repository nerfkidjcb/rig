return {
 {
      "williamboman/mason.nvim",
      config = function()
         require("mason").setup()
      end,
   },
   {
      "williamboman/mason-lspconfig.nvim",
      config = function()
         require("mason-lspconfig").setup({
            ensure_installed = {
               -- Lua
               "lua_ls",

               -- Python
               "pyright",

               -- C/C++
               "clangd",

               -- JavaScript/TypeScript/React
               "tsserver",
               "eslint",

               -- HTML/CSS
               "html",
               "cssls",

               -- JSON
               "jsonls",

               -- YAML
               "yamlls",

               -- TOML
               "taplo",
            }
         })
      end
   },
   {
      "neovim/nvim-lspconfig",
      config = function()
         local lspconfig = require("lspconfig")

         -- Lua
         lspconfig.lua_ls.setup({})

         -- Python
         lspconfig.pyright.setup({})

         -- C/C++
         lspconfig.clangd.setup({})

         -- JavaScript/TypeScript/React
         lspconfig.tsserver.setup({})
         lspconfig.eslint.setup({})

         -- HTML/CSS
         lspconfig.html.setup({})
         lspconfig.cssls.setup({})

         -- JSON
         lspconfig.jsonls.setup({})

         -- YAML
         lspconfig.yamlls.setup({})

         -- TOML
         lspconfig.taplo.setup({})

         vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, {})
         vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      end
   },
}

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
					-- Python
					"pyright",

					-- C/C++
					"clangd",

					-- Web
					"html",
					"cssls",
					"tsserver",
					"eslint",

					-- Lua
					"lua_ls",

					-- JSON
					"jsonls",

					-- YAML
					"yamlls",

					-- Rust / TOML
					"taplo",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Python
			lspconfig.pyright.setup({})

			-- C/C++
			lspconfig.clangd.setup({})

			-- Web
			lspconfig.html.setup({})
			lspconfig.cssls.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.eslint.setup({})

			-- Lua
			lspconfig.lua_ls.setup({})

			-- JSON
			lspconfig.jsonls.setup({})

			-- YAML
			lspconfig.yamlls.setup({})

			-- Rust / TOML
			lspconfig.taplo.setup({})

			vim.keymap.set("n", "<C-k>", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<C-j>", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<C-a>", vim.lsp.buf.code_action, {})
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = {
					-- Python
					"pylint",
					"mypy",
					"black",
					"isort",

					-- C/C++
					"clang-format",

					-- Web
					"eslint_d",

					-- Lua
					"stylua",

					-- JSON
					"prettier",

					-- YAML
					"yamllint",

					-- Web / Markdown / JSON / YAML
					"prettier",
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				sources = {
					-- Python
					null_ls.builtins.diagnostics.pylint,
					null_ls.builtins.diagnostics.mypy,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.isort,

					-- C/C++
					null_ls.builtins.formatting.clang_format,

					-- Lua
					null_ls.builtins.formatting.stylua,

					-- YAML
					null_ls.builtins.diagnostics.yamllint,

					-- Web / Markdown / JSON / YAML
					null_ls.builtins.formatting.prettier,
				},
				on_attach = function(client, bufnr)
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format()
							end,
						})
					end
				end,
			})
		end,
	},
}

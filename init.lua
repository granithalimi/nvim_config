vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamed"
vim.opt.wrap = false

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here

		-- colorscheme
		{
			"rose-pine/neovim",
			name = "rose-pine",
			priority = 1000, -- Ensure it loads first
			config = function()
				-- Set colorscheme (with optional settings)
				require("rose-pine").setup({
					variant = "moon", -- "main", "moon" (dark), "dawn" (light)
					disable_italics = false,
					-- disable_background = true,
				})
				vim.cmd("colorscheme rose-pine")
			end,
		},

		--telescope with treesitter
		{
			"nvim-telescope/telescope.nvim",
			tag = "0.1.8",
			-- or                              , branch = '0.1.x',
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local builtin = require("telescope.builtin")
				vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope find files" })
				vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
				vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
				vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
			end,
		},
		{
			"nvim-telescope/telescope-ui-select.nvim",
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
				})
				require("telescope").load_extension("ui-select")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "master",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = { "lua", "javascript", "php", "python", "tsx" },
					highlight = { enable = true },
					indent = { enable = true },
				})
			end,
		},
		-- Nvimtree
		{
			"nvim-tree/nvim-tree.lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("nvim-tree").setup({
					git = {
						enable = true,
						ignore = false,
					},
				})
			end,
		},
		-- Lualine
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("lualine").setup({
					options = {
						theme = "dracula",
					},
				})
			end,
		},
		-- window manager
		{
			"christoomey/vim-tmux-navigator",
			cmd = {
				"TmuxNavigateLeft",
				"TmuxNavigateDown",
				"TmuxNavigateUp",
				"TmuxNavigateRight",
				"TmuxNavigatePrevious",
				"TmuxNavigatorProcessList",
			},
			keys = {
				{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
				{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
			},
			-- mason
			{
				"mason-org/mason.nvim",
				config = function()
					require("mason").setup({
						ui = {
							interactive = true,
						},
					})
					vim.bo.modifiable = true
				end,
				opts = {},
			},
			{
				"mason-org/mason-lspconfig.nvim",
				config = function()
					require("mason-lspconfig").setup({
						ensure_installed = {
							"lua_ls",
							"ts_ls",
							"html",
							"cssls",
							"tailwindcss",
							"pyright",
							"intelephense",
							"jdtls",
						},
					})
				end,
				opts = {},
				dependencies = {
					{ "mason-org/mason.nvim", opts = {} },
					"neovim/nvim-lspconfig",
				},
			},
			{
				"neovim/nvim-lspconfig",
				config = function()
					local capabilities = require("cmp_nvim_lsp").default_capabilities()

					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
					})
					lspconfig.ts_ls.setup({
						capabilities = capabilities,
					})
					lspconfig.html.setup({
						capabilities = capabilities,
					})
					lspconfig.cssls.setup({
						capabilities = capabilities,
					})
					lspconfig.tailwindcss.setup({
						capabilities = capabilities,
					})
					lspconfig.pyright.setup({
						capabilities = capabilities,
					})
					lspconfig.intelephense.setup({
						capabilities = capabilities,
					})
					lspconfig.jdtls.setup({
						capabilities = capabilities,
					})

					vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
					vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
				end,
			},
			-- null-ls
			{
				"nvimtools/none-ls.nvim",
				config = function()
					local null_ls = require("null-ls")
					null_ls.setup({
						sources = {
							null_ls.builtins.formatting.stylua,
							null_ls.builtins.formatting.prettier,
							-- null_ls.builtins.diagnostics.eslint,
						},
					})
					vim.keymap.set("n", "<leader>jf", vim.lsp.buf.format, {})
				end,
			},
			-- autocomplition and snippets
			{
				"hrsh7th/cmp-nvim-lsp",
			},
			{
				"L3MON4D3/LuaSnip",
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
					"rafamadriz/friendly-snippets",
				},
			},
			{
				"hrsh7th/nvim-cmp",
				config = function()
					local cmp = require("cmp")
					require("luasnip.loaders.from_vscode").lazy_load()

					cmp.setup({
						snippet = {
							expand = function(args)
								require("luasnip").lsp_expand(args.body)
							end,
						},
						window = {
							completion = cmp.config.window.bordered(),
							documentation = cmp.config.window.bordered(),
						},
						mapping = cmp.mapping.preset.insert({
							["<C-j>"] = cmp.mapping.select_next_item(),
							["<C-k>"] = cmp.mapping.select_prev_item(),
							["<C-b>"] = cmp.mapping.scroll_docs(-4),
							["<C-f>"] = cmp.mapping.scroll_docs(4),
							["<C-Space>"] = cmp.mapping.complete(),
							["<C-e>"] = cmp.mapping.abort(),
							["<CR>"] = cmp.mapping.confirm({ select = true }),
							["<TAB>"] = cmp.mapping.confirm({ select = true }),
						}),
						sources = cmp.config.sources({
							{ name = "nvim_lsp" },
							{ name = "luasnip" }, -- For luasnip users.
						}, {
							{ name = "buffer" },
						}),
					})
				end,
			},
			-- autoclosing elems and brackets
			{
				"windwp/nvim-autopairs",
				event = "InsertEnter",
				config = function()
					require("nvim-autopairs").setup({})
				end,
			},
			{
				"windwp/nvim-ts-autotag",
				event = "InsertEnter",
				dependencies = { "nvim-treesitter/nvim-treesitter" },
				config = function()
					require("nvim-ts-autotag").setup()
				end,
			},
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

--keymaps
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("v", "jk", "<Esc>")

vim.keymap.set("n", "<C-e>", ":NvimTreeToggle<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<leader>to", ":tabnew<CR>")
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>")
vim.keymap.set("n", "<leader>tn", ":tabn<CR>")
vim.keymap.set("n", "<leader>tp", ":tabp<CR>")

vim.keymap.set("n", "<leader>sv", "<C-w>v")
vim.keymap.set("n", "<leader>sh", "<C-w>s")
vim.keymap.set("n", "<leader>se", "<C-w>=")
vim.keymap.set("n", "<leader>sx", ":close<CR>")

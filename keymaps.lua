-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Unbind conflicting defaults

-- Insert mode escape
vim.keymap.set({ "i", "v" }, "jk", "<Esc>", { desc = "Exit insert mode" })

-- Window splits
vim.keymap.set("n", "<leader>|", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<leader>-", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close window" })

-- Buffers
vim.keymap.set("n", "<S-l>", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<S-h>", "<Nop>", { desc = "Disabled" })
vim.keymap.set("n", "<leader>bd", "<Nop>", { desc = "Disabled" })

vim.keymap.set("n", "<leader>tn", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>tp", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>tx", function()
	local status, bd = pcall(require, "mini.bufremove")

	if status then
		bd.delete(0, false)
	else
		vim.cmd("bdelete")
	end
end, { desc = "Close current buffer" })

-- Plugins
vim.keymap.set("n", "<leader><leader>", "<Nop>", { desc = "Disabled" })

vim.keymap.set("n", "<C-e>", "<leader>e", { desc = "Toggle Explorer", remap = true })
vim.keymap.set("n", "<C-p>", function()
	if LazyVim and LazyVim.pick then
		LazyVim.pick("files")()
	else
		vim.cmd("FzfLua files")
	end
end, { desc = "Find files" })

-- Add this in plugins/cmp.lua
-- return {
--   "saghen/blink.cmp",
--   opts = {
--     keymap = {
--       ["<C-j>"] = { "select_next", "fallback" },
--       ["<C-k>"] = { "select_prev", "fallback" },
--     },
--   },
-- }

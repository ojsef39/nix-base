return {
	src = "https://github.com/kdheepak/lazygit.nvim",
	defer = true,
	dependencies = {
		{ src = "https://github.com/nvim-lua/plenary.nvim" },
	},
	config = function()
		-- Keymap
		vim.g.lazygit_floating_window_border_chars = { "", "", "", "", "", "", "", "" } -- remove window border
		vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit", silent = true })
	end,
}

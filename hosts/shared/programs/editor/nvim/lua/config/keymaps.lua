-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- remap redo to U
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo", noremap = false })

-- Rearrange visually selected lines in normal mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv", { silent = true })

-- Select and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Open diagnostics in a floating window
local opts = {
  focusable = false,
  close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  border = "rounded",
  source = "always",
  prefix = " ",
  scope = "cursor",
}
vim.keymap.set(
  "n",
  "E",
  ":lua vim.diagnostic.open_float(nil, opts) <cr>",
  { desc = "Floating Error thingy", silent = true }
)

-- Add text navigation keymaps
-- Map Home and End keys in normal mode
vim.keymap.set('n', '<Home>', '^', { noremap = true, silent = true })
vim.keymap.set('n', '<End>', '$', { noremap = true, silent = true })

-- Map Home and End keys in insert mode
vim.keymap.set('i', '<Home>', '<C-o>^', { noremap = true, silent = true })
vim.keymap.set('i', '<End>', '<C-o>$', { noremap = true, silent = true })

-- Handle escape sequences sent by tmux for Home and End keys
vim.keymap.set('', '<Esc>[H', '<Home>', { noremap = true, silent = true })
vim.keymap.set('', '<Esc>[F', '<End>', { noremap = true, silent = true })
vim.keymap.set('', '<Esc>OH', '<Home>', { noremap = true, silent = true })
vim.keymap.set('', '<Esc>OF', '<End>', { noremap = true, silent = true })
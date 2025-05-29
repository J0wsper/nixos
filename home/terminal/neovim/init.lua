vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Line numbers
vim.opt.number = true

-- Allowing yanking between panes
vim.opt.clipboard = {'unnamed', 'unnamedplus'}

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Conceal additional characters
vim.opt.conceallevel = 1

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  callback = function()
	  vim.highlight.on_yank()
  end,
})

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', {desc = 'Move focus to the left window'})
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', {desc = 'Move focus to the right window'})
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', {desc = 'Move focus to the bottom window'})
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', {desc = 'Move focus to the top window'})

-- require("telescope")
-- require("dropbar")
--  require("lsp")
require ("misc")
--  require("snippets")
 require("theme")
--  require("clipboard")
--  require("folding")
--  require("treesitter")

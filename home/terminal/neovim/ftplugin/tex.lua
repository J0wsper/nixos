local opts = { noremap = true, silent = true }

vim.api.nvim_buf_set_keymap(
	0,
	"n",
	"<leader>lj",
	":silent !/Applications/Skim.app/Contents/SharedSupport/displayline <C-r>=line('.')<CR> %<.pdf<CR>",
	opts
)
vim.api.nvim_buf_set_keymap(0, "n", "<leader>lm", ":!latexmk -pdf -synctex=1 %<CR>", opts)

-- TODO: This **does not work** right now. It's an attempt to use sioyek.
-- sioyek blocks if it isn't already open. Otherwise I _think_ this is right.
-- vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lj', ":silent !sioyek --forward-search-file %:p --forward-search-line <C-r>=line('.')<CR> --forward-search-column <C-r>=col('.')<CR> --new-window %:p:r.pdf<CR>", opts)

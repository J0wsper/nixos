vim.cmd("setlocal spell")
vim.cmd("setlocal fo+=at")
vim.cmd("setlocal shiftwidth=2")
vim.cmd("setlocal conceallevel=0")
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.cmd("setlocal textwidth=100")
	end,
})

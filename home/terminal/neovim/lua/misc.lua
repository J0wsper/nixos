vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smarttab = false
vim.o.number = true
vim.o.undofile = true

-- Diagnostic information
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "open diagnostic floating window" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "open diagnostic buffer" })

-- Setting up assorted configs
require("Comment").setup()
require("which-key").setup({})
require("noice").setup()
require("trouble").setup({})
require("leap").set_default_mappings()
require("gitsigns").setup({})

-- Dropbar configuration
local dropbar_api = require("dropbar.api")
vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })

-- Telescope configuration
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>sb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "Telescope help tags" })

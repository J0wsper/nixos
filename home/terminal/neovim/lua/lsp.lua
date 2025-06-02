-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  --[[
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp says not to use omnifunc with nvim_cmp
  --]]

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,  { buffer = bufnr, desc = "go to declaration" })
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition,  { buffer = bufnr, desc = "go to definition" })
  -- NOTE: this is handled in lua/folding.lua, where 'K' is bound to show the fold if on a fold, or dispatch to the LSP if not on a fold
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover,  { buffer = bufnr, desc = "hover" })
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,  { buffer = bufnr, desc = "go to implementation" })
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,  { buffer = bufnr, desc = "see signature" })
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder,  { buffer = bufnr, desc = "add workspace folder" })
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder,  { buffer = bufnr, desc = "remove workspace folder" })
  vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',  { buffer = bufnr, desc = "list workspace folders" })
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition,  { buffer = bufnr, desc = "see type definition" })
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename,  { buffer = bufnr, desc = "rename" })
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,  { buffer = bufnr, desc = "code actions" })
  vim.keymap.set('n', 'gr', vim.lsp.buf.references,  { buffer = bufnr, desc = "see references" })
  vim.keymap.set('n', '<space>f', vim.lsp.buf.format, { buffer = bufnr, desc = "format" })

  -- code lens 
  -- (taken from https://discuss.ocaml.org/t/neovim-setup-in-lua-for-ocaml/10586)
  if client.server_capabilities.codeLensProvider then
    local codelens = vim.api.nvim_create_augroup(
      'LSPCodeLens',
      { clear = true }
    )
    vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'CursorHold' }, {
      group = codelens,
      callback = function()
        vim.lsp.codelens.refresh()
      end,
      buffer = bufnr,
    })
  end

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    vim.keymap.set('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf , desc = "toggle inlay hints"})
    end)
  end

end
--
-- Add additional capabilities supported by nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'sourcekit', 'texlab', 'pylsp', 'bashls', 'html', 'rust_analyzer', 'fish_lsp' }
-- The HTML server says you should do
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- but it is covered by default_capabilities(), so I don't
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      hint = {
        enable = true,
      }
    }
  }
}
lspconfig.nil_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- settings = {
  --   ['nil'] = {
  --     nix = {
  --       flake = {
  --         autoArchive = true
  --       }
  --     }
  --   }
  -- }
}
lspconfig.nixd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  -- settings = {
  --   nixd = {
  --     formatting = {
  --       command = { "nix", "fmt" }
  --     },
  --     options = {
  --       nixos = {
  --         expr = ''
  --       },
  --       ['nix-darwin'] = {
  --         expr = ''
  --       },
  --       ['home-manager'] = {
  --         expr = ''
  --       }
  --     }
  --   }
  -- }
}
-- clangd_extensions now wants you to set up like this anyway
lspconfig.clangd.setup {
  on_attach = function (client, bufnr)
    on_attach(client, bufnr)
    require("clangd_extensions.inlay_hints").setup_autocmd()
    require("clangd_extensions.inlay_hints").set_inlay_hints()
  end,
  capabilities = capabilities,
}

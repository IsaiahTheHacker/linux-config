set number
set mouse=a
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
syntax on
set noswapfile
set nobackup
set nowritebackup

call plug#begin()

" Theme and UI
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }

" UI enhancements
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'sindrets/winshift.nvim'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Autocompletion core
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Snippet engine and integration
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" LSP support
Plug 'neovim/nvim-lspconfig'

call plug#end()


colorscheme catppuccin-mocha


lua << EOF

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup {}  -- for Lua, or change to other languages

-- Setup cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
})

require("catppuccin").setup{}
vim.cmd.colorscheme("catppuccin")

require'nvim-treesitter.configs'.setup {
  ensure_installed = {"lua", "rust", "c", "c_sharp", "c_make", "cpp", "go"}, -- or use a list: { "lua", "python", "javascript" }
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}

require("lualine").setup{
  options = {
    theme = "catppuccin",
    icons_enabled = true,
    section_separators = "",
    component_separators = ""
  }
}
EOF

nnoremap <C-q> :Neotree toggle<CR>
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>

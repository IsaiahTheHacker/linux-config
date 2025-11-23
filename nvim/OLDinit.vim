set number
set relativenumber
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
Plug 'nvim-tree/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'romgrk/barbar.nvim'
call plug#end()

colorscheme catppuccin-mocha

lua << EOF
-- Modern LSP setup using vim.lsp.config (Neovim 0.11+)
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
  filetypes = { 'lua' },
})

vim.lsp.enable('lua_ls')

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
})
vim.lsp.enable('clangd')

-- Rust LSP (rust-analyzer)
vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  root_markers = { 'Cargo.toml', 'rust-project.json' },
  filetypes = { 'rust' },
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')

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

-- Theme setup
require("catppuccin").setup{}
vim.cmd.colorscheme("catppuccin")

-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"lua", "rust", "c", "c_sharp", "cpp", "go"},
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  }
}

-- Lualine
require("lualine").setup{
  options = {
    theme = "catppuccin",
    icons_enabled = true,
    section_separators = "",
    component_separators = ""
  }
}

require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,
  numhl = false,
  linehl = false,
  word_diff = false,
  watch_gitdir = {
    follow_files = true
  },
  current_line_blame = false,
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Navigation
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, buffer = bufnr})

    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, buffer = bufnr})

    -- Actions
    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {buffer = bufnr})
    vim.keymap.set('n', '<leader>tb', gs.toggle_current_line_blame, {buffer = bufnr})
    vim.keymap.set('n', '<leader>hd', gs.diffthis, {buffer = bufnr})
  end
})

EOF

nnoremap <C-q> :Neotree toggle<CR>
nnoremap gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
nnoremap <C-e> :wqa<CR>
nnoremap <F5> :w<CR>:vsplit \| terminal ./build.sh<CR>G<S-a>

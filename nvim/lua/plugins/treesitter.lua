return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',  -- This runs :TSUpdate after install (replaces vim-plug's 'do')
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {"lua", "rust", "c", "c_sharp", "cpp", "go", "cmake", "markdown", "gitignore"},
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      }
    }
  end
}

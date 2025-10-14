vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/after"))
vim.opt.runtimepath:append(vim.fn.expand("~/.config/neovim"))
vim.cmd("source " .. vim.fn.expand("~/.vimrc"))

require'nvim-treesitter'.setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
  ensure_installed = {
    "c", "lua", "vim", "markdown", "markdown_inline",
    "rust", "python", "hcl"
  },
  auto_install = true,
  highlight = {
    enable = true,
  }

}

vim.cmd.colorscheme "solarized8"

require('lspconfig').pyright.setup{
  settings = {
    python = {
      pythonPath = vim.fn.system('poetry run which python'):gsub('%s+', ''),
    }
  }
}

-- Optionally, show diagnostics as virtual text
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
})

vim.keymap.set("n", "gd", function()
    require("telescope.builtin").lsp_definitions({jump_type = "tab"})
  end,
  { noremap = true, silent = true }
)

vim.keymap.set("n", "gr", function()
    require("telescope.builtin").live_grep()
  end,
  { noremap = true, silent = true }
)

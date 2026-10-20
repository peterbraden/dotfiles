vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/after"))
-- Shared with vim, which loads them via pathogen
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/bundle/ctrlp.vim"))
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/bundle/startify.vim"))
vim.cmd("source " .. vim.fn.expand("~/.vimrc"))

-- Pinned to the legacy master branch, which is configured via .configs
require'nvim-treesitter.configs'.setup {
  parser_install_dir = vim.fn.stdpath('data') .. '/site',
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

-- The project's poetry virtualenv python, or nil when there isn't one
local function poetry_python(root)
  if not root or vim.fn.executable('poetry') == 0 then
    return nil
  end
  local out = vim.fn.system({'poetry', '-C', root, 'env', 'info', '-e'})
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

require('lspconfig').pyright.setup{
  -- Resolved when pyright starts for a project, not on every nvim start.
  -- Without a poetry env pyright falls back to its default interpreter.
  before_init = function(_, config)
    local python = poetry_python(config.root_dir)
    if python then
      config.settings.python.pythonPath = python
    end
  end,
  settings = {
    python = {}
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

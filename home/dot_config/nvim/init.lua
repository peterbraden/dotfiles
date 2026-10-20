vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.runtimepath:prepend(vim.fn.expand("~/.vim"))
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/after"))
-- Shared with vim, which loads them via pathogen
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/bundle/ctrlp.vim"))
vim.opt.runtimepath:append(vim.fn.expand("~/.vim/bundle/startify.vim"))
vim.cmd("source " .. vim.fn.expand("~/.vimrc"))

-- nvim-treesitter main branch (needs nvim 0.12+ and tree-sitter-cli)
local ts_languages = {
  "c", "lua", "vim", "markdown", "markdown_inline",
  "rust", "python", "hcl"
}
require'nvim-treesitter'.setup {
  install_dir = vim.fn.stdpath('data') .. '/site',
}
-- Asynchronous, and a no-op once the parsers are installed
require'nvim-treesitter'.install(ts_languages)

-- Highlighting is Neovim's own; nvim-treesitter only provides parsers.
-- pcall: some filetypes have no parser, which is fine.
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

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

-- nvim-lspconfig supplies the pyright defaults (lsp/pyright.lua)
vim.lsp.config('pyright', {
  -- Resolved when pyright starts for a project, not on every nvim start.
  -- Without a poetry env pyright falls back to its default interpreter.
  before_init = function(_, config)
    local python = poetry_python(config.root_dir)
    if python then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = python
    end
  end,
})
vim.lsp.enable('pyright')

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

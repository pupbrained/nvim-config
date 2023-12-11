require('hoverhints').setup()
require('hlchunk').setup({})
require('lsp-lens').setup()
require('diagflow').setup({})

require('tabout').setup()
require('codeium').setup()
require('ultimate-autopair').setup()
require('guess-indent').setup()
require('satellite').setup()

require("hover").setup({
  init = function()
    require("hover.providers.lsp")
    require('hover.providers.gh')
    require('hover.providers.gh_user')
    require('hover.providers.man')
    require('hover.providers.dictionary')
  end,

  preview_opts = {
    border = 'rounded'
  },

  preview_window = false,

  title = true,

  mouse_providers = {
    'LSP'
  },

  mouse_delay = 1000
})

-- Setup keymaps
vim.keymap.set("n", "<Leader>k", require("hover").hover, { desc = "hover.nvim" })
vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })

--vim.g.haskell_tools = {
--  tools = {
--    hover = {
--      stylize_markdown = true,
--      auto_focus = true,
--    },
--  },
--}

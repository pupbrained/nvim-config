require('eagle').setup()
require('lsp-lens').setup()
require('tabout').setup()
require('codeium').setup()
require('ultimate-autopair').setup()
require('guess-indent').setup()
require('satellite').setup()
require('savior').setup()
require('tint').setup()

require('toggleterm').setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
  open_mapping = [[<C-t>]],
})

local saved_terminal

require('flatten').setup({
  window = {
    open = 'alternate',
  },
  callbacks = {
    should_block = function(argv)
      return vim.tbl_contains(argv, '-b')
    end,
    pre_open = function()
      local term = require('toggleterm.terminal')
      local termid = term.get_focused_id()
      saved_terminal = term.get(termid)
    end,
    post_open = function(bufnr, winnr, ft, is_blocking)
      if is_blocking and saved_terminal then
        saved_terminal:close()
      else
        vim.api.nvim_set_current_win(winnr)
      end

      if ft == 'gitcommit' or ft == 'gitrebase' then
        vim.api.nvim_create_autocmd('BufWritePost', {
          buffer = bufnr,
          once = true,
          callback = vim.schedule_wrap(function()
            vim.api.nvim_buf_delete(bufnr, {})
          end),
        })
      end
    end,
    block_end = function()
      vim.schedule(function()
        if saved_terminal then
          saved_terminal:open()
          saved_terminal = nil
        end
      end)
    end,
  },
})

local builtin = require('veil.builtin')

require('veil').setup({
  sections = {
    builtin.sections.animated(builtin.headers.frames_nvim, {
      hl = { fg = '#5de4c7' },
    }),
    builtin.sections.buttons({
      {
        icon = '',
        text = 'Find Files',
        shortcut = 'f',
        callback = function()
          require('telescope.builtin').find_files()
        end,
      },
      {
        icon = '',
        text = 'Find Word',
        shortcut = 'w',
        callback = function()
          require('telescope.builtin').live_grep()
        end,
      },
      {
        icon = '',
        text = 'Buffers',
        shortcut = 'b',
        callback = function()
          require('telescope.builtin').buffers()
        end,
      },
    }),
    builtin.sections.oldfiles(),
  },
})

require('surround-ui').setup({
  root_key = 'ys',
})

require('modes').setup({
  colors = {
    copy = '#fab387',
    delete = '#f38ba8',
    insert = '#94e2d5',
    visual = '#cba6f7',
  },
})

require('hlchunk').setup({
  chunk = {
    style = {
      { fg = '#a6e3a1' },
      { fg = '#313244' },
    },
  },
  line_num = {
    style = '#a6e3a1',
  },
  blank = {
    enable = false,
  },
})

require('hover').setup({
  init = function()
    require('hover.providers.lsp')
    require('hover.providers.gh')
    require('hover.providers.gh_user')
    require('hover.providers.man')
    require('hover.providers.dictionary')
  end,

  preview_opts = {
    border = 'rounded',
  },

  preview_window = false,

  title = true,

  mouse_providers = {
    'LSP',
  },

  mouse_delay = 1000,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local language_servers = require('lspconfig').util.available_servers()

for _, ls in ipairs(language_servers) do
  require('lspconfig')[ls].setup({
    capabilities = capabilities,
  })
end

local statuscol_builtin = require('statuscol.builtin')

require('statuscol').setup({
  relculright = true,
  segments = {
    { text = { statuscol_builtin.foldfunc }, click = 'v:lua.ScFa' },
    { text = { '%s' }, click = 'v:lua.ScSa' },
    { text = { statuscol_builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
  },
})

require('ufo').setup({
  fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = (' 󰁂 %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0

    for _, chunk in ipairs(virtText) do
      local chunkText = chunk[1]
      local chunkWidth = vim.fn.strdisplaywidth(chunkText)

      if targetWidth > curWidth + chunkWidth then
        table.insert(newVirtText, chunk)
      else
        chunkText = truncate(chunkText, targetWidth - curWidth)
        local hlGroup = chunk[2]
        table.insert(newVirtText, { chunkText, hlGroup })
        chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if curWidth + chunkWidth < targetWidth then
          suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
        end
        break
      end

      curWidth = curWidth + chunkWidth
    end

    table.insert(newVirtText, { suffix, 'MoreMsg' })

    return newVirtText
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  once = true,
  callback = vim.lsp.codelens.refresh,
})

vim.ui.select = require('dropbar.utils.menu').select

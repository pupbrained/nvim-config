require('lsp-lens').setup()
require('tabout').setup()
require('ultimate-autopair').setup()
require('guess-indent').setup()
require('savior').setup()

require('wtf').setup({
  openai_api_key = 'awawa',
  base_url = 'http://localhost:3040/v1',
  search_engine = 'kagi',
})

require('tint').setup({
  window_ignore_function = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufid, 'buftype')
    local floating = vim.api.nvim_win_get_config(winid).relative ~= ''

    return buftype == 'nofile' or floating
  end,
})

require('hover').setup({
  init = function()
    require('hover.providers.lsp')
  end,
  preview_opts = {
    border = 'rounded',
  },
  preview_window = true,
  title = false,
  mouse_providers = {
    'LSP',
  },
  mouse_delay = 500,
})

require('actions-preview').setup({
  telescope = {
    sorting_strategy = 'ascending',
    layout_strategy = 'vertical',
    layout_config = {
      width = 0.8,
      height = 0.9,
      prompt_position = 'top',
      preview_cutoff = 20,
      preview_height = function(_, _, max_lines)
        return max_lines - 15
      end,
    },
  },
})

require('toggleterm').setup({
  direction = 'float',
  float_opts = { border = 'curved' },
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
    exclude_filetypes = {
      ['neo-tree'] = true,
      trouble = true,
      toml = true,
    },
    style = {
      { fg = '#a6e3a1' },
      { fg = '#313244' },
    },
  },
  line_num = {
    enable = false,
  },
  blank = {
    enable = false,
  },
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

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  once = true,
  callback = vim.lsp.codelens.refresh,
})

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
  float = {
    border = 'rounded',
  },
  virtual_text = {
    prefix = function(diagnostic)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return ' '
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return ' '
      elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        return ' '
      else
        return ' '
      end
    end,
  },
})

vim.ui.select = require('dropbar.utils.menu').select

vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = 'hover.nvim (mouse)' })

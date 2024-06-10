-- Random things
require('lsp-lens').setup()
require('tabout').setup()
require('ultimate-autopair').setup()
require('guess-indent').setup()
require('savior').setup()
require('scope').setup()

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()

parser_config.nu = {
  filetype = 'nu',
}

-- Tabby
local util = require('tabby.util')

local hl_tabline_fill = util.extract_nvim_hl('lualine_c_normal')
local hl_tabline = util.extract_nvim_hl('lualine_b_normal')
local hl_tabline_sel = util.extract_nvim_hl('lualine_a_normal')

local function tab_label(tabid, active)
  local icon = active and ' ' or ' '
  local number = vim.api.nvim_tabpage_get_number(tabid)
  local name = util.get_tab_name(tabid)
  return string.format(' %s %d: %s ', icon, number, name)
end

local presets = {
  hl = 'lualine_c_normal',
  layout = 'tab_only',
  head = {
    { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
    { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
  active_tab = {
    label = function(tabid)
      return {
        tab_label(tabid, true),
        hl = { fg = '#1e1e2e', bg = hl_tabline_sel.bg },
      }
    end,
    left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        tab_label(tabid, false),
        hl = { fg = hl_tabline.fg, bg = hl_tabline_fill.bg },
      }
    end,
    left_sep = { ' ', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    right_sep = { ' ', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
  },
}

require('tabby').setup({ tabline = presets })

-- Surround
local surround_config = require('nvim-surround.config')

require('nvim-surround').setup({
  surrounds = {
    ['('] = {
      add = { '(', ')' },
      find = function()
        return surround_config.get_selection({ motion = '2i(' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    ['{'] = {
      add = { '{', '}' },
      find = function()
        return surround_config.get_selection({ motion = '2i{' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    ['<'] = {
      add = { '<', '>' },
      find = function()
        return surround_config.get_selection({ motion = '2i<' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    ['['] = {
      add = { '[', ']' },
      find = function()
        return surround_config.get_selection({ motion = '2i[' })
      end,
      delete = '^(. ?)().-( ?.)()$',
    },
    ["'"] = {
      add = { "'", "'" },
      find = function()
        return surround_config.get_selection({ motion = "2i'" })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['"'] = {
      add = { '"', '"' },
      find = function()
        return surround_config.get_selection({ motion = '2i"' })
      end,
      delete = '^(.)().-(.)()$',
    },
    ['`'] = {
      add = { '`', '`' },
      find = function()
        return surround_config.get_selection({ motion = '2i`' })
      end,
      delete = '^(.)().-(.)()$',
    },
  },
})

-- WTF
require('wtf').setup({
  openai_api_key = 'awawa',
  base_url = 'http://localhost:3040/v1',
  search_engine = 'kagi',
})

-- Tint
require('tint').setup({
  window_ignore_function = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufid, 'buftype')
    local floating = vim.api.nvim_win_get_config(winid).relative ~= ''

    return buftype == 'nofile' or floating
  end,
})

require('glow-hover').setup({
  max_width = 50,
  padding = 10,
  border = 'shadow',
  glow_path = 'glow',
})

-- Actions Preview
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

-- Terminal
require('toggleterm').setup({
  direction = 'float',
  float_opts = { border = 'curved' },
  open_mapping = [[<C-t>]],
})

-- Flatten
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

-- Veil
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

-- Modes
require('modes').setup({
  colors = {
    copy = '#fab387',
    delete = '#f38ba8',
    insert = '#94e2d5',
    visual = '#cba6f7',
  },
})

-- HLChunk
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

-- LSP
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

-- Dropbar
vim.ui.select = require('dropbar.utils.menu').select
vim.keymap.set('n', '<leader>r', function()
  return ':IncRename ' .. vim.fn.expand('<cword>')
end, { expr = true })

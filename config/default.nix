{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  sources = callPackage ../_sources/generated.nix {};

  mkVimPlugin = sources: vimUtils.buildVimPlugin {inherit (sources) src pname version;};

  alternate-toggler-nvim = mkVimPlugin sources.alternate-toggler-nvim;
  boo-nvim = mkVimPlugin sources.boo-nvim;
  hlchunk-nvim = mkVimPlugin sources.hlchunk-nvim;
  lsp-lens-nvim = mkVimPlugin sources.lsp-lens-nvim;
  eagle-nvim = mkVimPlugin sources.eagle-nvim;
  modes-nvim = mkVimPlugin sources.modes-nvim;
  satellite-nvim = mkVimPlugin sources.satellite-nvim;
  savior-nvim = mkVimPlugin sources.savior-nvim;
  surround-ui-nvim = mkVimPlugin sources.surround-ui-nvim;
  ultimate-autopair-nvim = mkVimPlugin sources.ultimate-autopair-nvim;
  veil-nvim = mkVimPlugin sources.veil-nvim;
  vim-reason-plus = mkVimPlugin sources.vim-reason-plus;
in {
  config = {
    enableMan = false;
    package = neovim-nightly;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;

    extraConfigLua = builtins.readFile ./init.lua;

    colorschemes.catppuccin = {
      enable = true;

      settings = {
        flavour = "mocha";
        terminalColors = true;

        integrations = {
          fidget = true;
          gitsigns = true;
          illuminate.enabled = true;
          leap = true;
          mini.enabled = true;
          navic.enabled = true;
          neotree = true;
          telescope.enabled = true;
          treesitter = true;
          treesitter_context = true;

          dap = {
            enabled = true;
            enable_ui = true;
          };

          indent_blankline = {
            enabled = true;
            colored_indent_levels = true;
          };

          native_lsp = {
            enabled = true;
            inlay_hints.background = true;

            virtual_text = {
              errors = ["italic"];
              hints = ["italic"];
              warnings = ["italic"];
              information = ["italic"];
            };

            underlines = {
              errors = ["underline"];
              hints = ["underline"];
              warnings = ["underline"];
              information = ["underline"];
            };
          };
        };

        styles = {
          booleans = ["bold" "italic"];
          conditionals = ["bold"];
          functions = ["bold"];
          keywords = ["italic"];
          loops = ["bold"];
          operators = ["bold"];
          properties = ["italic"];
        };
      };
    };

    opts = {
      autoindent = true;
      cindent = true;
      completeopt = "menuone,menuone,noselect";
      conceallevel = 2;
      expandtab = true;
      fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:";
      foldcolumn = "1";
      foldenable = true;
      foldlevel = 99;
      foldlevelstart = 99;
      laststatus = 3;
      list = true;
      mousemoveevent = true;
      number = true;
      relativenumber = true;
      shiftwidth = 0;
      showmode = false;
      smarttab = true;
      tabstop = 2;
      undofile = true;
    };

    globals = {
      NERDDefaultAlign = "left";
      closetag_filetypes = "html,xhtml,phtml,vue";
      mapleader = " ";
      neovide_cursor_animation_length = 2.5e-2;
      neovide_cursor_vfx_mode = "railgun";
      rust_recommended_style = false;
    };

    keymaps = with lib; let
      mkNormalLeader = key: action: desc: {
        key = concatStrings ["<Leader>" key];
        action = concatStrings ["<CMD>" action "<CR>"];
        options.desc = desc;
      };

      mkMap = key: action: mode: desc: {
        inherit key action mode;
        options.desc = desc;
      };
    in [
      (mkNormalLeader "e" "Neotree toggle" "Toggle File Explorer")
      (mkNormalLeader "b" "Telescope buffers" "Manage Buffers")
      (mkNormalLeader "a" "Lspsaga code_action" "Code Action")
      (mkNormalLeader "d" "Lspsaga show_cursor_diagnostics" "Show Cursor Diagnostics")
      (mkNormalLeader "n" "Lspsaga diagnostic_jump_next" "Next Diagnostic")
      (mkNormalLeader "N" "Lspsaga diagnostic_jump_prev" "Previous Diagnostic")
      (mkNormalLeader "k" "lua require('boo').boo()" "LSP Hover")
      (mkNormalLeader "s" "lua require('ssr').open()" "Structural Search and Replace")
      (mkMap "<Leader>f" "<Esc><CMD>'<,'>fold<CR>" "v" "Fold Selected")
      (mkMap "s" "<Esc><CMD>'<,'>!sort<CR>" "v" "Sort Selected Lines")
    ];

    plugins = {
      cmp-cmdline.enable = true;
      dap.enable = true;
      fidget.enable = true;
      leap.enable = true;
      lsp-lines.enable = true;
      lspkind.enable = true;
      neo-tree.enable = true;
      surround.enable = true;
      toggleterm.enable = true;
      which-key.enable = true;

      bufferline = {
        enable = true;
        separatorStyle = "slope";
      };

      conform-nvim = {
        enable = true;

        formatters = {
          fourmolu.args = [
            "--indentation=2"
            "--ghc-opt"
            "-XImportQualifiedPost"
            "--stdin-input-file"
            "$FILENAME"
          ];

          pretty-php.args = [
            "-s2"
            "$FILENAME"
          ];

          #rustfmt.args = [
          #  "--config"
          #  "unstable_features=true,tab_spaces=2,reorder_impl_items=true,indent_style=Block,normalize_comments=true,imports_granularity=Crate,imports_layout=HorizontalVertical,group_imports=StdExternalCrate"
          #];
        };

        formattersByFt = {
          json = ["jq"];
          haskell = ["fourmolu"];
          lua = ["stylua"];
          nix = ["alejandra"];
          rust = ["rustfmt"];
          typescript = ["eslint"];
          vue = ["eslint"];
          ocaml = ["ocamlformat"];
          php = ["pretty-php"];
        };

        extraOptions.format_on_save = {
          timeout_ms = 1000;
          lsp_fallback = true;
        };
      };

      instant = {
        enable = true;
        settings.username = "mars";
      };

      lsp = {
        enable = true;

        onAttach = ''
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                require('mini.trailspace').trim()
                require('mini.trailspace').trim_last_lines()
              end,
            })
          end

          vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh,
          })

          vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
        '';

        servers = {
          eslint.enable = true;
          gleam.enable = true;
          gopls.enable = true;
          intelephense.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          tailwindcss.enable = true;
          taplo.enable = true;
          tsserver.enable = true;
          vls.enable = true;
          volar.enable = true;
        };
      };

      lspsaga = {
        enable = true;
        lightbulb.sign = false;
      };

      lualine = {
        enable = true;
      };

      mini = {
        enable = true;
        modules = {
          move = {};
          trailspace = {};
        };
      };

      noice = {
        enable = true;
        routes = [
          {
            filter = {
              event = "msg_show";
              kind = "";
              find = "written";
            };
            opts.skip = true;
          }
        ];
      };

      notify = {
        enable = true;
        maxWidth = 100;

        extraOptions = {
          render = "compact";
        };
      };

      cmp = {
        enable = true;

        settings = {
          experimental.ghost_text.hlgroup = "Comment";
          window.completion.border = "rounded";

          mapping = {
            __raw = ''
              cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              })
            '';
          };

          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };

          sources = [
            {name = "buffer";}
            {name = "codeium";}
            {name = "luasnip";}
            {name = "nvim_lsp";}
            {name = "path";}
          ];

          formatting.format = lib.mkForce ''
            require('lspkind').cmp_format({
              mode = "symbol",
              maxwidth = 50,
              ellipsis_char = '...',
              symbol_map = { Codeium = "", }
            })
          '';
        };
      };

      nvim-jdtls = {
        enable = true;
        data =
          if pkgs.stdenv.isDarwin
          then "/Users/marshall/.jdtls/workspaces"
          else "/home/marshall/.jdtls/workspaces";
      };

      rustaceanvim = {
        enable = true;
        server.settings.check.command = "clippy";
      };

      telescope = {
        enable = true;
        extensions.file-browser.enable = true;

        settings.pickers.buffers = {
          previewer = false;
          show_all_buffers = true;
          sort_lastused = true;
          theme = "dropdown";

          mappings = {
            i = {"<c-d>" = "delete_buffer";};
            n = {"d" = "delete_buffer";};
          };
        };
      };

      treesitter = {
        enable = true;
        nixGrammars = true;
      };
    };

    extraPlugins = with vimPlugins; [
      alternate-toggler-nvim
      boo-nvim
      codeium-nvim
      dressing-nvim
      dropbar-nvim
      flatten-nvim
      guess-indent-nvim
      haskell-tools-nvim
      hlchunk-nvim
      eagle-nvim
      lsp-lens-nvim
      modes-nvim
      nerdcommenter
      nvim-ufo
      satellite-nvim
      savior-nvim
      ssr-nvim
      statuscol-nvim
      surround-ui-nvim
      tabout-nvim
      tint-nvim
      ultimate-autopair-nvim
      veil-nvim
      vim-closetag
      vim-cool
      vim-haskellConcealPlus
      vim-reason-plus
    ];
  };
}

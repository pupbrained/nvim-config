{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  sources = callPackage ../_sources/generated.nix {};

  mkVimPlugin = sources: vimUtils.buildVimPlugin {inherit (sources) src pname version;};

  alternate-toggler-nvim = mkVimPlugin sources.alternate-toggler-nvim;
  diagflow-nvim = mkVimPlugin sources.diagflow-nvim;
  hlchunk-nvim = mkVimPlugin sources.hlchunk-nvim;
  lsp-lens-nvim = mkVimPlugin sources.lsp-lens-nvim;
  hoverhints-nvim = mkVimPlugin sources.hoverhints-nvim;
  satellite-nvim = mkVimPlugin sources.satellite-nvim;
  ultimate-autopair-nvim = mkVimPlugin sources.ultimate-autopair-nvim;
in {
  config = {
    enableMan = false;
    package = neovim-nightly;

    extraConfigLua = builtins.readFile ./init.lua;

    colorschemes.catppuccin = {
      enable = true;
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

          inlay_hints = {
            background = true;
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

    options = {
      autoindent = true;
      cindent = true;
      completeopt = "menuone,menuone,noselect";
      expandtab = true;
      fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:";
      foldcolumn = "1";
      foldenable = true;
      foldlevel = 99;
      laststatus = 3;
      list = true;
      number = true;
      relativenumber = true;
      shell = "bash";
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
      (mkNormalLeader "e" "Neotree toggle" "Toggle NeoTree")
      (mkNormalLeader "b" "Telescope buffers" "Manage Buffers")
      (mkNormalLeader "a" "Lspsaga code_action" "Code Action")
      (mkNormalLeader "d" "Lspsaga show_cursor_diagnostics" "Show Cursor Diagnostics")
      (mkNormalLeader "n" "Lspsaga diagnostic_jump_next" "Next Diagnostic")
      (mkNormalLeader "N" "Lspsaga diagnostic_jump_prev" "Previous Diagnostic")
      (mkNormalLeader "k" "lua require('hover').hover()" "Hover")
      (mkMap "<C-t>" "<CMD>Lspsaga term_toggle<CR>" "n" "Toggle Terminal")
      (mkMap "<C-t>" "<C-\\><C-n><CMD>Lspsaga term_toggle<CR>" "t" "Toggle Terminal")
      (mkMap "<Leader>f" "<Esc><CMD>'<,'>fold<CR>" "v" "Fold Selected")
      (mkMap "gK" "<CMD>lua require('hover').hover_select()<CR>" "n" "Hover (Select)")
      (mkMap "s" "<Esc><CMD>'<,'>!sort<CR>" "v" "Sort Selected Lines")
    ];

    plugins = {
      cmp-cmdline.enable = true;
      dap.enable = true;
      fidget.enable = true;
      leap.enable = true;
      lspkind.enable = true;
      neo-tree.enable = true;
      surround.enable = true;
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

          rustfmt.args = [
            "--config"
            "unstable_features=true,tab_spaces=2,reorder_impl_items=true,indent_style=Block,normalize_comments=true,imports_granularity=Crate,imports_layout=HorizontalVertical,group_imports=StdExternalCrate"
          ];
        };

        formattersByFt = {
          haskell = ["fourmolu"];
          lua = ["stylua"];
          nix = ["alejandra"];
          rust = ["rustfmt"];
          typescript = ["eslint_d"];
          vue = ["eslint_d"];
        };

        extraOptions.format_on_save = {
          timeout_ms = 1000;
          lsp_fallback = true;
        };
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
        '';

        servers = {
          eslint.enable = true;
          gopls.enable = true;
          hls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;
          tailwindcss.enable = true;
          tsserver.enable = true;
          typst-lsp.enable = true;
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

      nvim-cmp = {
        enable = true;

        experimental.ghost_text.hlgroup = "Comment";

        sources = [
          {name = "codeium";}
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
        ];

        window.completion.border = "rounded";

        mapping = {"<CR>" = "cmp.mapping.confirm()";};
        mappingPresets = ["insert"];

        formatting.format = lib.mkForce ''
          require('lspkind').cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = '...',
            symbol_map = { Codeium = "", }
          })
        '';
      };

      rust-tools = {
        enable = true;
        server.check.command = "clippy";
      };

      telescope = {
        enable = true;

        extraOptions = {
          pickers = {
            buffers = {
              show_all_buffers = true;
              sort_lastused = true;
              theme = "dropdown";
              previewer = false;
              mappings = {
                i = {
                  "<c-d>" = "delete_buffer";
                };
                n = {
                  "d" = "delete_buffer";
                };
              };
            };
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
      codeium-nvim
      diagflow-nvim
      dressing-nvim
      dropbar-nvim
      guess-indent-nvim
      hlchunk-nvim
      hover-nvim
      hoverhints-nvim
      lsp-lens-nvim
      nerdcommenter
      nvim-ufo
      satellite-nvim
      tabout-nvim
      ultimate-autopair-nvim
      vim-closetag
      vim-cool
      vim-haskellConcealPlus
    ];
  };
}

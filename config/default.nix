{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  username = "marshall";

  homeDir =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  sources = callPackage ../_sources/generated.nix {};

  mkVimPlugin = sources: vimUtils.buildVimPlugin {inherit (sources) src pname version;};

  alternate-toggler-nvim = mkVimPlugin sources.alternate-toggler-nvim;
  hlchunk-nvim = mkVimPlugin sources.hlchunk-nvim;
  lsp-lens-nvim = mkVimPlugin sources.lsp-lens-nvim;
  hover-nvim = mkVimPlugin sources.hover-nvim;
  modes-nvim = mkVimPlugin sources.modes-nvim;
  rustaceanvim = mkVimPlugin sources.rustaceanvim;
  satellite-nvim = mkVimPlugin sources.satellite-nvim;
  savior-nvim = mkVimPlugin sources.savior-nvim;
  surround-ui-nvim = mkVimPlugin sources.surround-ui-nvim;
  ultimate-autopair-nvim = mkVimPlugin sources.ultimate-autopair-nvim;
  veil-nvim = mkVimPlugin sources.veil-nvim;
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
            inlay_hints.background = false;

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

      mkNormal = key: action: desc: {
        inherit key;
        action = concatStrings ["<CMD>" action "<CR>"];
        options.desc = desc;
      };

      mkMap = key: action: mode: desc: {
        inherit key action mode;
        options.desc = desc;
      };
    in [
      (mkMap "f" "<Esc><CMD>'<,'>fold<CR>" "v" "Fold Selected")
      (mkMap "s" "<Esc><CMD>'<,'>!sort<CR>" "v" "Sort Selected Lines")
      (mkMap "<C-_>" "<Plug>NERDCommenterToggle" ["n" "v"] "Comment Selected Lines")
      (mkNormal "<leader><space>" "lua require('alternate-toggler').toggleAlternate()" "Toggle Boolean")
      (mkNormal "<C-l>" "BufferLineCycleNext" "Next Buffer")
      (mkNormal "<C-h>" "BufferLineCyclePrev" "Previous Buffer")
      (mkNormal "gp" "Gitsigns preview_hunk" "Preview Hunk")
      (mkNormal "gr" "Gitsigns reset_hunk" "Reset Hunk")
      (mkNormal "gs" "Gitsigns stage_hunk" "Stage Hunk")
      (mkNormal "gu" "Gitsigns undo_stage_hunk" "Undo Stage Hunk")
      (mkNormalLeader "lg" "LazyGit" "Open LazyGit")
      (mkNormalLeader "bb" "Telescope buffers" "Manage Buffers")
      (mkNormalLeader "bd" "BufferLinePickClose" "Close Buffers")
      (mkNormalLeader "e" "Neotree toggle" "Toggle File Explorer")
      (mkNormalLeader "d" "lua vim.lsp.buf.definition()" "Go to Definition")
      (mkNormalLeader "cl" "lua vim.lsp.codelens.run()" "Code Lens")
      (mkNormalLeader "n" "lua vim.diagnostic.goto_next()" "Next Diagnostic")
      (mkNormalLeader "N" "lua vim.diagnostic.goto_prev()" "Previous Diagnostic")
      (mkNormalLeader "hs" "lua require('haskell-tools').hoogle.hoogle_signature()" "Hoogle Signature")
      (mkNormalLeader "rr" "lua require('haskell-tools').repl.toggle()" "Toggle Repl for Package")
      (mkNormalLeader "rq" "lua require('haskell-tools').repl.quit()" "Quit Repl")
      (mkNormalLeader "a" "lua require('actions-preview').code_actions()" "Code Action")
      (mkNormalLeader "k" "lua require('hover').hover()" "LSP Hover")
      (mkNormalLeader "s" "lua require('ssr').open()" "Structural Search and Replace")
    ];

    plugins = {
      cmp-cmdline.enable = true;
      codeium-nvim.enable = true;
      crates-nvim.enable = true;
      dap.enable = true;
      fidget.enable = true;
      leap.enable = true;
      lspkind.enable = true;
      lsp-lines.enable = true;
      lualine.enable = true;
      neo-tree.enable = true;
      surround.enable = true;
      toggleterm.enable = true;
      which-key.enable = true;

      bufferline = {
        enable = true;
        separatorStyle = "slope";
      };

      cmp = {
        enable = true;

        settings = {
          experimental.ghost_text.hlgroup = "Comment";
          window.completion.border = "rounded";

          mapping.__raw = ''
            cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            })
          '';

          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          sources = [
            {name = "codeium";}
            {name = "buffer";}
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

      conform-nvim = {
        enable = true;

        formatters.fourmolu.args = [
          "--indentation=2"
          "--ghc-opt"
          "-XImportQualifiedPost"
          "--stdin-input-file"
          "$FILENAME"
        ];

        formattersByFt = {
          json = ["jq"];
          haskell = ["fourmolu"];
          lua = ["stylua"];
          nix = ["alejandra"];
          rust = ["rustfmt"];
          typescript = ["eslint"];
          vue = ["eslint"];
        };

        extraOptions.format_on_save = {
          timeout_ms = 1000;
          lsp_fallback = true;
        };
      };

      gitsigns = {
        enable = true;
        settings = {
          signcolumn = false;
          numhl = true;
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
          lua-ls.enable = true;
          nixd.enable = true;
          tailwindcss.enable = true;
          taplo.enable = true;
          tsserver.enable = true;
          volar.enable = true;
        };
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
        extraOptions.render = "compact";
      };

      nvim-ufo = {
        enable = true;
        enableGetFoldVirtText = true;
        foldVirtTextHandler = ''
          function(virtText, lnum, endLnum, width, truncate)
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
          end
        '';
      };

      nvim-jdtls = let
        data = "${homeDir}/.jdtls/workspaces";
      in {
        inherit data;
        enable = builtins.pathExists data;
      };

      obsidian = let
        dir = "${homeDir}/Documents/Obsidian\\ Vault";
      in {
        settings = {inherit dir;};
        enable = builtins.pathExists dir;
      };

      rustaceanvim = {
        enable = true;
        package = rustaceanvim;
        server.settings.check.command = "clippy";
      };

      telescope = {
        enable = true;
        extensions.file-browser.enable = true;

        settings.pickers.buffers = {
          previewer = false;
          show_all_buffers = true;
          sort_lastused = true;
          ignore_current_buffer = true;
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
      # Preview code actions
      actions-preview-nvim
      # Toggle boolean values
      alternate-toggler-nvim
      # UI improvements
      dressing-nvim
      # Breadcrumbs
      dropbar-nvim
      # Open files from your terminal
      flatten-nvim
      # Guess indentation
      guess-indent-nvim
      # Haskell LSP improvements
      haskell-tools-nvim
      # Highlight code blocks
      hlchunk-nvim
      # LSP info on mouse-over
      hover-nvim
      # Git integration
      lazygit-nvim
      # Codelens
      lsp-lens-nvim
      # Line decorations
      modes-nvim
      # Commenting
      nerdcommenter
      # Scrollbar decorations
      satellite-nvim
      # Autosave
      savior-nvim
      # Structural search and replace
      ssr-nvim
      # Status column
      statuscol-nvim
      # Which-key integration for surround
      surround-ui-nvim
      # Tab out of various enclosings
      tabout-nvim
      # Dim inactive windows
      tint-nvim
      # Auto-close pairs
      ultimate-autopair-nvim
      # Dashboard
      veil-nvim
      # Auto-close tags
      vim-closetag
      # Better hlsearch
      vim-cool
    ];
  };
}

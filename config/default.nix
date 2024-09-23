{
  lib,
  pkgs,
  helpers,
  ...
}: let
  username = "marshall";

  homeDir =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";

  mkVimPlugin = sources: pkgs.vimUtils.buildVimPlugin {inherit (sources) src pname version;};

  sources = import ../_sources/generated.nix {inherit (pkgs) fetchFromGitHub fetchgit fetchurl dockerTools;};

  extraPlugins = lib.attrsets.mapAttrsToList (_: value: mkVimPlugin value) sources;
in {
  config = {
    enableMan = false;

    autoCmd = [
      {
        command = "set guicursor=a:ver1-blinkon0";
        event = "VimLeave";
        pattern = "*";
      }
    ];

    clipboard = {
      register = "unnamedplus";

      providers = {
        wl-copy.enable = true;
        xclip.enable = true;
      };
    };

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
    extraConfigLua = builtins.readFile ./init.lua;

    colorschemes.catppuccin = {
      enable = true;

      settings = {
        flavour = "mocha";
        term_colors = true;

        integrations = {
          fidget = true;
          flash = true;
          gitsigns = true;
          illuminate.enabled = true;
          mini.enabled = true;
          navic.enabled = true;
          nvimtree = true;
          telescope.enabled = true;
          treesitter = true;
          treesitter_context = true;

          dap = {
            enabled = true;
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
              errors = ["undercurl"];
              hints = ["undercurl"];
              warnings = ["undercurl"];
              information = ["undercurl"];
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
      guifont = "Maple Mono NF:h12";
      ignorecase = true;
      laststatus = 3;
      list = true;
      mousemoveevent = true;
      number = true;
      relativenumber = true;
      shiftwidth = 0;
      showmode = false;
      signcolumn = "no";
      smarttab = true;
      tabstop = 2;
      undofile = true;
      wrap = true;
    };

    globals = {
      closetag_filetypes = "html,xhtml,phtml,vue";
      mapleader = " ";
      neovide_refresh_rate = 165;
      neovide_floating_blur = false;
      neovide_floating_shadow = false;
      neovide_cursor_animation_length = 2.5e-2;
      neovide_cursor_vfx_mode = "railgun";
      rust_recommended_style = false;
    };

    keymaps = with lib; let
      mkNormalLeader = key: action: desc: {
        key = concatStrings ["<Leader>" key];
        action = concatStrings ["<CMD>" action "<CR>"];
        options = {inherit desc;};
      };

      mkNormal = key: action: desc: {
        inherit key;
        action = concatStrings ["<CMD>" action "<CR>"];
        options = {inherit desc;};
      };

      mkMap = key: action: mode: desc: {
        inherit key action mode;
        options = {inherit desc;};
      };
    in [
      (mkMap "a" "2i" "v" "Select Around")
      (mkMap "f" "<Esc><CMD>'<,'>fold<CR>" "v" "Fold Selected")
      (mkMap "s" "<Esc><CMD>'<,'>!sort<CR>" "v" "Sort Selected Lines")
      (mkMap "<C-d>" "<C-d>zz" "n" "Move down half-page")
      (mkMap "<C-u>" "<C-u>zz" "n" "Move up half-page")
      (mkMap "s" "<CMD>lua require('flash').remote()<CR>" ["n" "x" "o"] "Flash Jump")
      (mkMap "S" "<CMD>lua require('flash').treesitter()<CR>" ["n" "x" "o"] "Flash Treesitter")
      (mkMap "<C-s>" "<CMD>lua require('flash').toggle()<CR>" "o" "Flash Toggle")
      (mkNormal "gb" "Gitsigns blame_line" "Show Git Blame")
      (mkNormal "gp" "Gitsigns preview_hunk" "Preview Hunk")
      (mkNormal "gr" "Gitsigns reset_hunk" "Reset Hunk")
      (mkNormal "gs" "Gitsigns stage_hunk" "Stage Hunk")
      (mkNormal "gu" "Gitsigns undo_stage_hunk" "Undo Stage Hunk")
      (mkNormal "<C-h>" "lua require('smart-splits').resize_left()" "Resize Left")
      (mkNormal "<C-j>" "lua require('smart-splits').resize_down()" "Resize Down")
      (mkNormal "<C-k>" "lua require('smart-splits').resize_up()" "Resize Up")
      (mkNormal "<C-l>" "lua require('smart-splits').resize_right()" "Resize Right")
      (mkNormal "<A-h>" "lua require('smart-splits').move_cursor_left()" "Move Left")
      (mkNormal "<A-j>" "lua require('smart-splits').move_cursor_down()" "Move Down")
      (mkNormal "<A-k>" "lua require('smart-splits').move_cursor_up()" "Move Up")
      (mkNormal "<A-l>" "lua require('smart-splits').move_cursor_right()" "Move Right")
      (mkNormal "<A-\\>" "lua require('smart-splits').move_cursor_previous()" "Move to Previous")
      (mkNormal "<S-h>" "bp" "Switch to Previous Buffer")
      (mkNormal "<S-l>" "bn" "Switch to Next Buffer")
      (mkNormal "<S-Tab>" "tabn" "Next Tab")
      (mkNormalLeader "<leader>h" "lua require('smart-splits').swap_buf_left()" "Move Left")
      (mkNormalLeader "<leader>j" "lua require('smart-splits').swap_buf_down()" "Move Down")
      (mkNormalLeader "<leader>k" "lua require('smart-splits').swap_buf_up()" "Move Up")
      (mkNormalLeader "<leader>l" "lua require('smart-splits').swap_buf_right()" "Move Right")
      (mkNormalLeader "t" "lua require('alternate-toggler').toggleAlternate()" "Toggle Alternate")
      (mkNormalLeader "lg" "LazyGit" "Open LazyGit")
      (mkNormalLeader "b" "lua require('buffer_manager.ui').toggle_quick_menu()" "Manage Buffers")
      (mkNormalLeader "e" "NvimTreeToggle" "Toggle File Tree")
      (mkNormalLeader "d" "lua vim.diagnostic.open_float()" "Show Line Diagnostics")
      (mkNormalLeader "ld" "Trouble diagnostics" "Show File Diagnostics")
      (mkNormalLeader "lf" "Trouble lsp_definitions" "LSP Definitions")
      (mkNormalLeader "ls" "Trouble lsp_document_symbols" "Symbols")
      (mkNormalLeader "lr" "Trouble lsp_references" "References")
      (mkNormalLeader "lt" "Trouble todo" "Todos")
      (mkNormalLeader "cp" "lua require('crates').show_popup()" "Show Crate Info")
      (mkNormalLeader "n" "lua vim.diagnostic.goto_next()" "Next Diagnostic")
      (mkNormalLeader "N" "lua vim.diagnostic.goto_prev()" "Previous Diagnostic")
      (mkNormalLeader "a" "lua require('actions-preview').code_actions()" "Code Action")
      (mkNormalLeader "k" "lua vim.lsp.buf.hover()" "LSP Hover")
      (mkNormalLeader "s" "lua require('ssr').open()" "Structural Search and Replace")
    ];

    plugins = {
      auto-session.enable = true;
      cmp-cmdline.enable = true;
      codeium-nvim.enable = true;
      comment.enable = true;
      direnv.enable = true;
      fidget.enable = true;
      flash.enable = true;
      inc-rename.enable = true;
      lspkind.enable = true;
      luasnip.enable = true;
      nvim-tree.enable = true;
      smart-splits.enable = true;
      todo-comments.enable = true;
      twilight.enable = true;
      which-key.enable = true;

      clangd-extensions = {
        enable = true;
        inlayHints.inline = "true";
        enableOffsetEncodingWorkaround = true;
        ast = {
          roleIcons = {
            type = "";
            declaration = "";
            expression = "";
            specifier = "";
            statement = "";
            templateArgument = "";
          };

          kindIcons = {
            compound = "";
            recovery = "";
            translationUnit = "";
            packExpansion = "";
            templateTypeParm = "";
            templateTemplateParm = "";
            templateParamObject = "";
          };
        };
      };

      cmp = {
        enable = true;

        settings = {
          experimental.ghost_text.hlgroup = "Comment";
          window.completion.border = "rounded";
          window.documentation.border = "rounded";

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
            {name = "crates";}
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

        formattersByFt = {
          "*" = ["trim_whitespace"];
          cmake = ["cmake_format"];
          cpp = ["clang-format"];
          css = ["prettier"];
          haskell = ["fourmolu"];
          html = ["prettier"];
          json = ["jq"];
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

      crates-nvim = {
        enable = true;

        extraOptions = {
          popup.border = "rounded";

          text = {
            loading = " Loading";
            version = " %s";
            prerelease = " %s";
            yanked = " %s";
            nomatch = " No match";
            upgrade = " %s";
            error = " Error fetching crate";
          };
        };
      };

      dap = {
        enable = true;
        adapters.executables.lldb.command = "lldb-vscode";
        configurations = let
          lldb = ["cpp"];
        in
          builtins.listToAttrs (map (language: {
              name = language;
              value = [
                {
                  name = "Launch";
                  request = "launch";
                  type = "lldb";
                  cwd = "\${workspaceFolder}";
                  program = helpers.mkRaw ''
                    function()
                      return vim.fn.input('Executable path: ', vim.fn.getcwd() .. '/', 'file')
                    end
                  '';
                  args = helpers.mkRaw ''
                    function()
                      local arguments_string = vim.fn.input('Executable arguments: ')
                      return vim.split(arguments_string, " +")
                    end
                  '';

                  initCommands = lib.mkIf (language == "rust") (helpers.mkRaw ''
                    function()
                      local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

                      local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                      local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

                      local commands = {}
                      local file = io.open(commands_file, 'r')
                      if file then
                        for line in file:lines() do
                          table.insert(commands, line)
                        end
                        file:close()
                      end
                      table.insert(commands, 1, script_import)

                      return commands
                    end
                  '');
                }
              ];
            })
            lldb);

        extensions = {
          dap-ui.enable = true;
          dap-virtual-text.enable = true;
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
        inlayHints = true;

        preConfig = ''
          vim.diagnostic.config({
            float = {
              border = 'rounded',
            },
          })
        '';

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

          vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
        '';

        servers = {
          clangd = {
            enable = true;
            package = pkgs.llvmPackages_19.clang-tools;
          };

          zls = {
            enable = true;
            package = null;
          };

          cmake.enable = true;
          eslint.enable = true;
          lua-ls.enable = true;
          nil-ls.enable = true;
          ocamllsp.enable = true;
          tailwindcss.enable = true;
          taplo.enable = true;
          tsserver.enable = true;
          vls.enable = true;
          volar.enable = true;
        };
      };

      lualine = {
        enable = true;

        tabline = {};
        extensions = [];

        componentSeparators = {
          left = "";
          right = "";
        };

        sectionSeparators = {
          left = "";
          right = "";
        };

        inactiveSections = {
          lualine_a = ["filename"];
          lualine_b = [];
          lualine_c = [];
          lualine_x = ["filetype"];
          lualine_y = [];
          lualine_z = ["location"];
        };

        sections = {
          lualine_a = [
            {
              name = "mode";
              separator.left = "";
              padding.left = 1;
              padding.right = 2;
            }
          ];
          lualine_b = [
            "filename"
            "branch"
          ];
          lualine_c = [
            "%="
            {
              name = "buffers";
              extraConfig.symbols.alternate_file = "";
            }
          ];
          lualine_x = [
            "encoding"
            {
              name = "fileformat";
              padding.left = 1;
              padding.right = 2;
            }
          ];
          lualine_y = ["filetype" "progress"];
          lualine_z = [
            {
              name = "location";
              separator.right = "";
              padding.left = 2;
              padding.right = 1;
            }
          ];
        };
      };

      mini = {
        enable = true;
        modules = {
          move = {
            mappings = {
              left = "<A-H>";
              down = "<A-J>";
              up = "<A-K>";
              right = "<A-L>";

              line_left = "<A-H>";
              line_down = "<A-J>";
              line_up = "<A-K>";
              line_right = "<A-L>";
            };
          };

          trailspace = {};
        };
      };

      noice = {
        enable = true;
        presets = {
          inc_rename = true;
          lsp_doc_border = true;
        };

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
        package = mkVimPlugin sources.rustaceanvim;
      };

      spider = {
        enable = true;
        skipInsignificantPunctuation = false;

        keymaps.motions = {
          b = "b";
          e = "e";
          ge = "ge";
          w = "w";
        };
      };

      statuscol = {
        enable = true;
        settings = {
          relculright = true;

          segments = [
            {
              text = ["%s"];
              click = "v:lua.ScSa";
            }
            {
              text = [
                {
                  __raw = "require('statuscol.builtin').lnumfunc";
                }
              ];
              click = "v:lua.ScLa";
            }
            {
              text = [
                " "
                {
                  __raw = "require('statuscol.builtin').foldfunc";
                }
                " "
              ];
              condition = [
                {
                  __raw = "require('statuscol.builtin').not_empty";
                }
                true
                {
                  __raw = "require('statuscol.builtin').not_empty";
                }
              ];
              click = "v:lua.ScFa";
            }
          ];
        };
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

      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<C-t>]]";
          float_opts.border = "curved";
        };
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
      };

      trouble = {
        enable = true;

        settings = {
          use_diagnostic_signs = true;
          focus = true;

          win = {
            border = "rounded";
            size = 0.2;
          };

          modes = {
            diagnostics = {
              title = "Diagnostics";
              mode = "diagnostics";
              preview = {
                type = "split";
                relative = "win";
                position = "right";
                size = 0.4;
              };
            };
          };
        };
      };

      zen-mode = {
        enable = true;
        settings = {
          plugins = {
            gitsigns.enabled = true;
            wezterm = {
              enabled = true;
              font = "+2";
            };
          };

          window = {
            width = 0.8;
            options.foldcolumn = "0";
          };

          on_open = ''
            function(win)
              if vim.g.neovide then
                vim.g.neovide_scale_factor = 1.5
              end
            end
          '';

          on_close = ''
            function()
              if vim.g.neovide then
                vim.g.neovide_scale_factor = 1
              end
            end
          '';
        };
      };
    };

    extraPlugins =
      extraPlugins
      ++ (with pkgs.vimPlugins; [
        # Preview code actions
        actions-preview-nvim
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
        # Git integration
        lazygit-nvim
        # Tab scopes
        scope-nvim
        # Structural search and replace
        ssr-nvim
        # Surround
        nvim-surround
        # Window picker
        nvim-window-picker
        # Tabs
        tabby-nvim
        # Dim inactive windows
        tint-nvim
        # Auto-close tags
        vim-closetag
        # Better hlsearch
        vim-cool
      ]);
  };
}

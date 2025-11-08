{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];
  
  programs.nixvim = {
    enable = true;
    
    # Options de base
    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      wrap = false;
      swapfile = false;
      backup = false;
      undofile = true;
      hlsearch = true;
      incsearch = true;
      ignorecase = true;
      smartcase = true;
      termguicolors = true;
      scrolloff = 8;
      updatetime = 50;
      signcolumn = "yes";
      mousescroll = "ver:3,hor:0";
    };
    
    globals.mapleader = " ";
    
    colorschemes.catppuccin.enable = true;
    
    # Icônes et UI
    plugins.web-devicons.enable = true;
    plugins.lualine.enable = true;
    
    # GitHub Copilot via copilot-lua (intégré avec blink-cmp)
    plugins.copilot-lua = {
      enable = true;
      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
    };
    
    # Keymaps
    keymaps = [
      # Général
      {
        mode = "n";
        key = "<leader>w";
        action = ":w<CR>";
        options = {
          desc = "Save file";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>q";
        action = ":q<CR>";
        options = {
          desc = "Quit";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<Esc>";
        action = ":noh<CR>";
        options = {
          desc = "Clear search highlight";
          silent = true;
        };
      }
      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options = {
          desc = "Find files";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options = {
          desc = "Live grep";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options = {
          desc = "Find buffers";
          silent = true;
        };
      }

    ];
    
    # Plugin pour intégrer Copilot avec blink-cmp
    plugins.blink-copilot.enable = true;
    
    # Complétion avec blink-cmp
    plugins.blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
          "<C-space>" = [ "show" "show_documentation" "hide_documentation" ];
          "<C-e>" = [ "hide" ];
          "<CR>" = [ "accept" "fallback" ];
          "<Tab>" = [ "select_next" "fallback" ];
          "<S-Tab>" = [ "select_prev" "fallback" ];
        };
        
        # Sources de complétion (incluant Copilot)
        sources = {
          default = [ "lsp" "path" "snippets" "buffer" "copilot" ];
          providers = {
            lsp = {
              name = "LSP";
              module = "blink.cmp.sources.lsp";
              fallbacks = [ "buffer" ];
              score_offset = 10; # Priorité élevée pour LSP (jdtls, etc.)
            };
            path = {
              name = "Path";
              module = "blink.cmp.sources.path";
              score_offset = 5; # Légèrement prioritaire
              opts = {
                trailing_slash = true;
                label_trailing_slash = true;
              };
            };
            snippets = {
              name = "Snippets";
              module = "blink.cmp.sources.snippets";
              score_offset = 8; # Plus prioritaire pour snippets utiles
              opts = {
                friendly_snippets = true;
                search_paths = [ "~/.config/nvim/snippets" ];
              };
            };
            buffer = {
              name = "Buffer";
              module = "blink.cmp.sources.buffer";
              score_offset = -5; # Moins prioritaire
              opts = {
                max_items = 5;
                keyword_pattern = "[\\w-]+";
              };
            };
            # Configuration Copilot pour blink-cmp
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              async = true;
              score_offset = 100; # Priorité élevée pour Copilot
              # Options avancées
              opts = {
                max_completions = 5;
                max_attempts = 8;
                kind = "Copilot";
                debounce = 150; # Réduit pour réponses plus rapides
                auto_refresh = {
                  backward = true;
                  forward = true;
                };
              };
            };
          };
        };
        
        # Snippets intégrés
        snippets = {
          expand.__raw = ''
            function(snippet) vim.snippet.expand(snippet) end
          '';
          active.__raw = ''
            function(filter)
              return vim.snippet.active(filter)
            end
          '';
          jump.__raw = ''
            function(direction)
              vim.snippet.jump(direction)
            end
          '';
        };
        
        # Apparence
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
        };
        
        # Comportement de la complétion
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
            };
          };
          menu = {
            draw = {
              columns = [
                [ "label" "label_description" "kind_icon" "kind" ]
              ];
            };
          };
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200; # Plus rapide
          };
          list = {
            max_items = 50; # Plus de suggestions visibles
            selection = {
              preselect = true;
              auto_insert = true;
            };
          };
          trigger = {
            show_on_insert_on_trigger_character = true;
          };
        };
        
        # Signatures de fonction
        signature = {
          enabled = true;
        };
      };
    };
    
    # friendly-snippets : collection de snippets
    extraPlugins = with pkgs.vimPlugins; [
      friendly-snippets
    ];
    
    # Typst
    plugins.typst-vim.enable = true;
    plugins.typst-preview.enable = true;
    
    # TypeScript
    plugins.typescript-tools.enable = true;
    
    # Linting
    plugins.lint.enable = true;
    
    # Treesitter
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        cpp
        java
        json
        lua
        make
        markdown
        nix
        regex
        rust
        toml
        vim
        vimdoc
        xml
        yaml
      ];
    };
    plugins.treesitter-context.enable = true;
    
    # Navigation et édition
    plugins.nvim-surround.enable = true;
    plugins.telescope.enable = true;
    plugins.yazi.enable = true;
    plugins.ccc.enable = true;
    plugins.comment.enable = true;
    
    # Debug
    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;
    
    # Git
    plugins.diffview.enable = true;
    plugins.gitsigns.enable = true;
    
    # LSP
    plugins.lsp = {
      enable = true;
      keymaps = {
        diagnostic = {
          "<leader>e" = "open_float";
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
        lspBuf = {
          "gd" = "definition";
          "gD" = "declaration";
          "gi" = "implementation";
          "gr" = "references";
          "K" = "hover";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
          "<leader>f" = "format";
        };
      };
      servers = {
        clangd = {
          enable = true;
          # Configuration améliorée pour C/C++
          cmd = [
            "clangd"
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
          settings = {
            clangd = {
              fallbackFlags = [ "-std=c++20" ];
            };
          };
        };
        jdtls = {
          enable = true;
          # Configuration améliorée pour Java
          settings = {
            java = {
              signatureHelp.enabled = true;
              contentProvider.preferred = "fernflower";
              completion = {
                favoriteStaticMembers = [
                  "org.junit.Assert.*"
                  "org.junit.Assume.*"
                  "org.junit.jupiter.api.Assertions.*"
                  "org.mockito.Mockito.*"
                  "org.mockito.ArgumentMatchers.*"
                  "java.util.Objects.requireNonNull"
                  "java.util.Objects.requireNonNullElse"
                  "java.util.stream.Collectors.*"
                ];
                filteredTypes = [
                  "com.sun.*"
                  "sun.*"
                  "jdk.*"
                ];
                importOrder = [ "java" "javax" "com" "org" ];
                maxResults = 50;
                enabled = true;
                guessMethodArguments = true;
              };
              implementationsCodeLens.enabled = true;
              referencesCodeLens.enabled = true;
              configuration = {
                runtimes = [ ];
                updateBuildConfiguration = "automatic";
              };
              autobuild.enabled = true;
              maven = {
                downloadSources = true;
                updateSnapshots = true;
              };
              eclipse = {
                downloadSources = true;
              };
              inlayHints = {
                parameterNames.enabled = "all";
              };
              codeGeneration = {
                generateComments = true;
                useBlocks = true;
                toString = {
                  template = "\${object.className} [\${member.name()}=\${member.value}, \${otherMembers}]";
                };
                hashCodeEquals = {
                  useJava7Objects = true;
                  useInstanceof = true;
                };
              };
              saveActions = {
                organizeImports = true;
              };
              sources = {
                organizeImports = {
                  starThreshold = 5;
                  staticStarThreshold = 3;
                };
              };
            };
          };
        };
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
      };
    };
    
    # Formatage
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          rust = [ "rustfmt" ];
          java = [ "google-java-format" ];
        };
      };
    };
  };
}

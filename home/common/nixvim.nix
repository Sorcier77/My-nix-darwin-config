{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # Core settings - Clean and professional
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
      laststatus = 3;
      showmode = false;
    };

    globals.mapleader = " ";

    # =============================================================================
    # MISTRALGRUV COLORSCHEME
    # Professional cybersecurity theme: Gruvbox readability + Mistral AI colors
    # =============================================================================
    extraConfigLua = ''
      -- MistralGruv: Deep dark with signature purple/blue
      local c = {
        bg0 = "#1a1a2e", bg1 = "#16213e", bg2 = "#0f3460",
        fg0 = "#e8e8e8", fg1 = "#d4d4d4", fg2 = "#a8a8a8",
        purple = "#9d75d0", blue = "#7aa2f7", cyan = "#7dcfff",
        green = "#98c379", red = "#e06c75", orange = "#e5895e", yellow = "#e5c07b"
      }
      
      local function hl(g, fg, bg, attr)
        local cmd = "highlight " .. g
        if fg then cmd = cmd .. " guifg=" .. fg end
        if bg then cmd = cmd .. " guibg=" .. bg end
        if attr then cmd = cmd .. " gui=" .. attr end
        vim.cmd(cmd)
      end
      
      vim.cmd("hi clear")
      vim.opt.background = "dark"
      
      -- Base
      hl("Normal", c.fg0, c.bg0)
      hl("Cursor", c.bg0, c.purple)
      hl("CursorLine", nil, c.bg1)
      hl("CursorLineNr", c.purple, c.bg1, "bold")
      hl("LineNr", c.fg2, c.bg0)
      hl("StatusLine", c.fg1, c.bg1)
      hl("StatusLineNC", c.fg2, c.bg1)
      hl("Visual", nil, c.bg2)
      hl("VertSplit", c.fg3, c.bg0)
      
      -- Syntax
      hl("Comment", c.fg2, nil, "italic")
      hl("Keyword", c.purple)
      hl("String", c.green)
      hl("Number", c.orange)
      hl("Function", c.blue)
      hl("Type", c.cyan)
      hl("Constant", c.yellow)
      hl("Identifier", c.fg0)
      hl("Operator", c.fg0)
      
      -- Diagnostics
      hl("ErrorMsg", c.red, nil, "bold")
      hl("WarningMsg", c.orange, nil, "bold")
      hl("LspDiagnosticsDefaultError", c.red)
      hl("LspDiagnosticsDefaultWarning", c.orange)
      hl("LspDiagnosticsDefaultInformation", c.blue)
      hl("LspDiagnosticsDefaultHint", c.cyan)
      
      -- Diff
      hl("DiffAdd", c.green, "#284728")
      hl("DiffDelete", c.red, "#452828")
      hl("DiffChange", c.yellow, "#283b45")
      
      vim.g.colors_name = "mistralgruv"
    '';

    # Disable catppuccin
    colorschemes.catppuccin.enable = false;

    # Plugins - Cyber Expert Essentials
    plugins.web-devicons.enable = true;
    plugins.lualine.enable = true;

    # OpSec: No Copilot
    plugins.copilot-lua.enable = false;

    # Completion
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
        sources = { default = [ "lsp" "path" "snippets" "buffer" ]; };
        appearance = { use_nvim_cmp_as_default = true; };
        completion = {
          accept = { auto_brackets = { enabled = true; }; };
          documentation = { auto_show = true; auto_show_delay_ms = 200; };
        };
        signature = { enabled = true; };
      };
    };

    # Navigation
    plugins.telescope = {
      enable = true;
      settings = {
        defaults = {
          file_ignore_patterns = [ "node_modules" ".git" "dist" "build" ];
          path_display = "smart";
          sorting_strategy = "ascending";
        };
      };
    };

    # Editing
    plugins.nvim-surround.enable = true;
    plugins.yazi.enable = true;
    plugins.ccc.enable = true;
    plugins.comment.enable = true;
    plugins.diffview.enable = true;
    plugins.gitsigns.enable = true;
    plugins.which-key.enable = true;
    plugins.trouble.enable = true;
    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;

    # LSP
    plugins.lsp = {
      enable = true;
      keymaps = {
        diagnostic = { "]d" = "goto_next"; "[d" = "goto_prev"; };
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
        clangd = { enable = true; cmd = [ "clangd" "--background-index" "--clang-tidy" ]; };
        rust_analyzer = { enable = true; installRustc = true; installCargo = true; };
        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              runtime.version = "LuaJIT";
              workspace.library = [ "${pkgs.neovim}/share/nvim/runtime" ];
              diagnostics.globals = [ "vim" ];
              telemetry.enable = false;
            };
          };
        };
        bashls = { enable = true; };
        jsonls = { enable = true; };
        yamlls = { enable = true; };
      };
    };

    # Treesitter
    plugins.treesitter = {
      enable = true;
      settings = { highlight.enable = true; indent.enable = true; };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash c cpp java json lua make markdown nix python rust yaml
      ];
    };
    plugins.treesitter-context.enable = true;

    # Formatting
    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          c = [ "clang-format" ];
          cpp = [ "clang-format" ];
          rust = [ "rustfmt" ];
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
        };
      };
    };

    # Snippets
    extraPlugins = with pkgs.vimPlugins; [ friendly-snippets ];
    
    # TypeScript
    plugins.typst-vim.enable = true;
    plugins.typst-preview.enable = true;
    plugins.typescript-tools.enable = true;
    plugins.lint.enable = true;
  };
}

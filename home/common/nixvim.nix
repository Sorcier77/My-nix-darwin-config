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
    # MISTRAL GRUVBOX MATERIAL COLORSCHEME
    # Dark theme with Mistral's signature orange + Gruvbox Material palette
    # =============================================================================
    extraConfigLua = ''
      -- Gruvbox Material Dark style with Mistral orange accent
      -- Charbon backgrounds + Gruvbox Material colors + soft Mistral orange
      local c = {
        -- Backgrounds (Charbon / Dark)
        bg0 = "#1a1a1a",      -- Main background (charbon)
        bg1 = "#282828",      -- Slightly lighter background
        bg2 = "#3a3a3a",      -- Selection/visual background
        bg3 = "#000000",      -- Pure black for contrast
        
        -- Foregrounds
        fg0 = "#ebdbb2",      -- Main foreground (Gruvbox light)
        fg1 = "#d4be98",      -- Dimmer foreground
        fg2 = "#a89984",      -- Comments, line numbers
        fg3 = "#83a598",      -- Blue-ish foreground
        
        -- Accent colors (Gruvbox Material Dark)
        red = "#fb4934",       -- Errors, deletions
        green = "#b8bb26",     -- Success, strings
        yellow = "#fabd2f",    -- Warnings, numbers, cursor
        blue = "#83a598",      -- Info, functions
        purple = "#d3869b",    -- Keywords, special
        orange = "#d68750",    -- Soft Mistral orange (constants, operators)
        cyan = "#8ec07c",      -- Types, hints
        
        -- Bright variants
        bright_red = "#ff8a8a",
        bright_orange = "#e5895e",
        bright_fg = "#fbf1c7"
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
      
      -- Base highlighting
      hl("Normal", c.fg0, c.bg0)
      hl("NormalFloat", c.fg0, c.bg1)
      hl("FloatBorder", c.fg2, c.bg1)
      hl("Cursor", c.bg0, c.yellow)  -- Yellow cursor like Gruvbox Material
      hl("CursorLine", nil, c.bg1)
      hl("CursorLineNr", c.yellow, c.bg1, "bold")
      hl("LineNr", c.fg2, c.bg0)
      hl("StatusLine", c.fg0, c.bg2, "bold")
      hl("StatusLineNC", c.fg2, c.bg1)
      hl("Visual", nil, c.bg2)
      hl("VertSplit", c.fg2, c.bg0)
      hl("WinSeparator", c.fg2, c.bg0)
      hl("Folded", c.fg2, c.bg1)
      hl("FoldColumn", c.fg2, c.bg0)
      hl("SignColumn", c.fg2, c.bg0)
      
      -- Syntax highlighting
      hl("Comment", c.fg2, nil, "italic")
      hl("Keyword", c.purple, nil, "bold")
      hl("Conditional", c.purple)
      hl("Repeat", c.purple)
      hl("Operator", c.fg0)  -- Less distracting operator color
      hl("String", c.green)
      hl("Character", c.green)
      hl("Number", c.yellow)
      hl("Boolean", c.yellow)
      hl("Float", c.yellow)
      hl("Function", c.blue)
      hl("Method", c.blue)
      hl("Identifier", c.fg0)
      hl("Type", c.cyan)
      hl("StorageClass", c.cyan)
      hl("Structure", c.cyan)
      hl("Constant", c.orange, nil, "bold")
      hl("PreProc", c.orange)
      hl("Include", c.orange)
      hl("Define", c.orange)
      hl("Macro", c.orange)
      hl("Tag", c.blue)
      hl("Special", c.cyan)
      hl("SpecialChar", c.cyan)
      hl("SpecialComment", c.fg2, nil, "italic")
      hl("Error", c.red, nil, "bold,underline")
      hl("Todo", c.bg0, c.yellow, "bold")
      
      -- LSP & Diagnostics
      hl("DiagnosticError", c.red)
      hl("DiagnosticWarn", c.yellow)
      hl("DiagnosticInfo", c.blue)
      hl("DiagnosticHint", c.cyan)
      hl("DiagnosticOk", c.green)
      hl("DiagnosticVirtualTextError", c.red, c.bg0)
      hl("DiagnosticVirtualTextWarn", c.yellow, c.bg0)
      hl("DiagnosticVirtualTextInfo", c.blue, c.bg0)
      hl("DiagnosticVirtualTextHint", c.cyan, c.bg0)
      hl("LspReferenceText", nil, c.bg2)
      hl("LspReferenceRead", nil, c.bg2, "underline")
      hl("LspReferenceWrite", nil, c.bg2, "underline")
      hl("LspCodeLens", c.fg2)
      hl("LspCodeLensSeparator", c.fg2)
      hl("LspSignatureActiveParameter", c.orange, nil, "underline")
      
      -- Completion menu
      hl("Pmenu", c.fg0, c.bg2)
      hl("PmenuSel", c.bg0, c.orange, "bold")
      hl("PmenuSbar", c.fg2, c.bg1)
      hl("PmenuThumb", c.fg0, c.bg2)
      
      -- Diff
      hl("DiffAdd", c.green, "#283a28")
      hl("DiffDelete", c.red, "#452828")
      hl("DiffChange", c.yellow, "#3a3a28")
      hl("DiffText", c.fg0, "#283b45")
      
      -- Search
      hl("Search", c.bg0, c.blue)  -- Blue instead of orange for search
      hl("IncSearch", c.bg0, c.blue)
      hl("CurSearch", c.bg0, c.bright_red)
      
      -- Messages
      hl("ErrorMsg", c.red, c.bg0, "bold")
      hl("WarningMsg", c.yellow, c.bg0, "bold")
      hl("MoreMsg", c.blue)
      hl("ModeMsg", c.fg0)
      hl("NonText", c.fg2)
      
      -- Tabs
      hl("TabLine", c.fg2, c.bg1)
      hl("TabLineSel", c.fg0, c.bg2)
      hl("TabLineFill", c.fg2, c.bg0)
      
      -- Spell checking
      hl("SpellBad", c.red, nil, "underline")
      hl("SpellCap", c.yellow, nil, "underline")
      hl("SpellRare", c.purple, nil, "underline")
      hl("SpellLocal", c.cyan, nil, "underline")
      
      -- Whitespace
      hl("Whitespace", c.fg2)
      hl("EndOfBuffer", c.bg0)
      
      -- UI Elements
      hl("MatchParen", c.orange, nil, "bold")
      hl("Directory", c.blue)
      hl("Title", c.fg0, nil, "bold")
      hl("Question", c.yellow)
      
      vim.g.colors_name = "mistral-gruvbox-material"
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

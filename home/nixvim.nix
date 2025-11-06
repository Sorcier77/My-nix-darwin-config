{ inputs, pkgs, ... }:

{
  
 

  imports = [ inputs.nixvim.homeModules.nixvim ];
  programs.nixvim = {
    enable = true;

    
    colorschemes.catppuccin.enable = true;
    


    # pour ajouter comme demandé les icones 
    plugins.web-devicons.enable = true;
    plugins.lualine.enable = true;
    plugins.blink-cmp = {
      enable = true;
      settings.keymap.preset = "default";
    };
    plugins.typst-vim.enable = true;
    plugins.typst-preview.enable = true;
    plugins.typescript-tools.enable = true;
    plugins.lint.enable = true;
    plugins.treesitter = {
	    enable = true;

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
   plugins.treesitter.settings = {
     highlight.enable = true;
     indent.enable = true;
   };
   plugins.nvim-surround.enable = true;
   plugins.telescope.enable = true;
   plugins.yazi.enable = true;
   plugins.ccc.enable = true;
   plugins.luasnip.enable = true;
   plugins.friendly-snippets.enable = true;
   plugins.dap.enable = true;
   plugins.dap-ui.enable = true;
   # git 
   plugins.diffview.enable = true;
   plugins.gitsigns.enable = true;

   plugins.lsp = {
  	enable = true;
  	servers = {
    	clangd.enable = true; # Pour C / C++
    	jdtls.enable = true;  # Pour Java
    	rust_analyzer.enable = true; # Pour Rust

  	};
   };
   # pour installer les dépendances
   plugins.lsp.servers.rust_analyzer.installRustc = true;
   plugins.lsp.servers.rust_analyzer.installCargo = true;

   # formatage 
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


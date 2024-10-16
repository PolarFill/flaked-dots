{ lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.term.utils.nvim;
  in {
    options.homeModules.default.applications.term.utils.nvim = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables and configures nvim!";
      };

      theme = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets the application theme";
      };

      nixvim = lib.options.mkOption {
        default = true;
	type = lib.types.bool;
	description = "Activates options set by nixvim";
      };

    };

  config = lib.mkIf cfg.enable {   

    programs.neovim = lib.mkIf ( cfg.nixvim == false ) {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    programs.nixvim = lib.mkIf ( cfg.nixvim == true ) {
      enable = true;
      enableMan = false;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      luaLoader.enable = true;
      colorschemes.${cfg.theme}.enable = true;

      globals = {
        netrw_liststyle = "3";
	netrw_banner = "0";
	netrw_browse_split = "3";
	netrw_winsize = "20";
      };

      keymaps = [
        {
	  key = "<leader>t";
	  action = "<cmd>Vexplore<CR>";
	  options.desc = "Opens a vertical netrw";
        }
      ];

      opts = {
        
	# Line numbers
        number = true;

	# Indentation
	autoindent = true;
	shiftwidth = 2;

        # Misc
	autoread = true;

      };

      plugins = {

	web-devicons.enable = true;
	treesitter.enable = true;

        which-key = {
          enable = true;
	};
      
	cmp = {
          enable = true;
	  settings = {
	    autoEnableSources = true;
	    sources = [
	      { name = "git"; }
              { name = "nvim_lsp"; }
              { name = "async_path"; }
              { name = "buffer"; }
	      { name = "buffer-lines"; }
	      { name = "nvim_lsp_signature_help"; }
	      { name = "nvim_lsp_document_symbol"; }
	    ];
	  };
	};

        lsp = {
          enable = true;
	  inlayHints = true;
	  servers = {
            pyright = { enable = true; };
	    nixd = { enable = true; };
	    rust_analyzer = {
	      enable = true;
              installRustc = false;
	      installCargo = false;
	      settings = {
                checkOnSave = true;
	        check = {
                  command = "clippy";
	        };
	      };
	    };
	  };
        };
      };
    };

  };
}

# Most of the complexity of this file steems from setting the theme in fish
# It only searches themes in specified paths, so we need to also include our theme in our home
# at build time.

{ inputs, pkgs, lib, config, osConfig, ... }:

  let
    cfg = config.homeModules.default.shell.fish;
  in {
    options.homeModules.default.shell.fish = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables the fish shell!";
      };

      theme = lib.options.mkOption {
        default = "default";
        type = lib.types.str;
	description = "Sets fish theme!";
      };
    };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ 
      fish 
    ];

    # We still use bash as our login shell because:
    # 1 - Fish is not posix-compliant, so it's not recommended for this task
    # 2 - We can't define our default user shell at home-manager scope, and
    # setting it outside would kinda limit us to only the fish shell

    # TODO: Put zoxide init at zoxide definition file

    programs.fish = {
      enable = true;
      interactiveShellInit = ''${pkgs.zoxide}/bin/zoxide init fish --cmd cd | source'';
      plugins = [
        { name = "sponge"; src = pkgs.fishPlugins.sponge; }
        { name = "colored-man-pages"; src = pkgs.fishPlugins.colored-man-pages; }
        { name = "async-prompt"; src = pkgs.fishPlugins.async-prompt; }
	{ 
	  name = "fish-abbreviation-tips";
	  src = pkgs.fetchFromGitHub {
            owner = "gazorby";
            repo = "fish-abbreviation-tips";
            rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
            hash = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
	  };
	}
      ];
    };

    programs.bash = {
        enable = true;
        initExtra = ''
	   if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
	   then
	     shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
	     exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
	   fi
        '';
    };
   
    home.file = { 
      theme = lib.mkIf ( cfg.theme != "default" ) { 
        source = ./themes; 
	target = ".config/fish/themes"; 
      };
    };
    
    programs.fish.shellInit = ''
      ${ if cfg.theme != "default" then "fish_config theme choose \"${cfg.theme}\"" else "" }
      function fish_command_not_found
	set_color red; 
	echo "This command doesn't exist, idiot"; 
	set_color normal
      end

      function fish_greeting
        # echo " $(set_color 008AD8)~~ Le $(set_color green)fish $(set_color 008AD8)shell ~~ ";
        echo "$(set_color 008AD8)Greetings, $(set_color F9B9A5; whoami | tr -d '\n'; set_color 008AD8)! \
Today is $(set_color 05C3DD; set -l LC_TIME en_US; date +"%A, %d/%m/%y, at %T") $(set_color 008AD8)";
	echo  "Running $TERM session with $(set_color 05C3DD; cat /etc/os-release | grep PRETTY_NAME | sed 's/PRETTY_NAME=//g; s/"//g'; set_color F9B9A5)";
      end
      '';
  };
}

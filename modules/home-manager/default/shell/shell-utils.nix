{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.shell.shellUtils;
  in {
    options.homeModules.default.shell.shellUtils = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
	description = "Enables some pretty cool shell utilities!";
      };
    };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide                                                               # cd utility
      bat bat-extras.batgrep bat-extras.batpipe bat-extras.prettybat       # Cat prettier substitution
      eza								   # ls alternative
      btop                                                                 # Resource monitor
      gping                                                                # Ping with a graph lol
      ripgrep ripgrep-all                                                  # Grep but faster
    ];
   
   home.shellAliases = {
       cat = "bat";
       ls = "eza";
       ping = "gping";
       grep = "rg";
   };
  };
}

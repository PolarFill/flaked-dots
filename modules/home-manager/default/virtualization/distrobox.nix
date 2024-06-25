{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.virtualization.distrobox;
  in {
    options.homeModules.default.virtualization.distrobox = {

      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Cool utility to drag-and-drop from any terminal!";
      };

      containers = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr ( lib.types.listOf lib.types.str );
	description = "Enables the desired defined containers";
      };

      nvidia = lib.options.mkOption {
        default = false;
	type = lib.types.bool;
	description = "Inserts nvidia drivers into the enabled containers";
      };

      deleteUnused = lib.options.mkOption {
        default = true;
	type = lib.types.bool;
	description = "Deletes previously declared containers if they are undeclared";
      };

    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      distrobox
      podman
    ];

    xdg.configFile."distrobox/assemble.ini" = lib.mkIf ( cfg.containers != null ) {
      text = lib.generators.toINI {} {

	arch-gaming = 
	if (builtins.elem "arch-gaming" cfg.containers)
	then {
	  nvidia = lib.trivial.boolToString cfg.nvidia;
	  image = "quay.io/toolbx/arch-toolbox:latest";
	  additional_packages = "neovim flatpak";
	  init_hooks = "${pkgs.writeShellScript "arch-gaming-init-hook" '' 
	  ''}";
	}
	else {};
 
        arch-aur = 
	if (builtins.elem "arch-aur" cfg.containers)
	then {
	  nvidia = lib.trivial.boolToString cfg.nvidia;
	  image = "quay.io/toolbx/arch-toolbox:latest";
	  additional_packages = "git base-devel";
	  init_hooks = "${pkgs.writeShellScript "arch-aur-init-hook" ''
	    if [ ! -d yay-bin ]; then
	      git clone https://aur.archlinux.org/yay-bin.git
	      cd yay-bin
	      echo y | makepkg -si
	    fi
	  ''}";
	}
	else {};

      };
    };

    systemd.user.services."distrobox-update" = {
      
      Unit = {
        Description = "automatically updates all distrobox containers!";
	After = [ "multi-user.target" ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type = "oneshot";
        Environment = "PATH=/run/current-system/sw/bin";
	ExecStart = "${pkgs.distrobox}/bin/distrobox upgrade -v --all";
      };

    };

    systemd.user.services."distrobox-assemble" = lib.mkIf ( cfg.containers != null ) {
    
      Unit = {
        Description = "builds the distrobox containers specified in my nix config!";
        After = [ "multi-user.target" ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type = "oneshot";
        Environment = "PATH=/run/current-system/sw/bin";
        ExecStart = "${pkgs.distrobox}/bin/distrobox assemble create -v --file /home/skynet/.config/distrobox/assemble.ini";
      };

    };

    systemd.user.services."distrobox-rm" = lib.mkIf (cfg.deleteUnused && cfg.containers != null) {
        
      Unit = {
        Description = "removes containers that were undeclared";
	After = [ "multi-user.target" ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };

      Service = {
        Type = "oneshot";
        Environment = "PATH=/run/current-system/sw/bin";
	ExecStart = "${pkgs.writeShellScript "distrobox-rm-script" '' 
          ${ if (builtins.elem "arch-gaming" cfg.containers) == false then "${pkgs.distrobox}/bin/distrobox rm -v -f arch-gaming" else "" }
          ${ if (builtins.elem "arch-aur" cfg.containers) == false then "${pkgs.distrobox}/bin/distrobox rm -v -f arch-aur" else "" }
	''}";	  
      };

    };

    home.sessionVariables = {
      PODMAN_IGNORE_CGROUPSV1_WARNING = "1";
    };

  };
}

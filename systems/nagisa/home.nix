{ inputs, outputs, config, lib, pkgs, ... }:

{
  
  imports = [ 
    outputs.homeModules.default 
    inputs.arkenfox.hmModules.default
    inputs.nur.hmModules.nur
  ];

  homeModules.default = {

    scripts = { enable = true; all = true; };

    shell.fish = { enable = true; theme = "rose-pine"; };
    shell.shellUtils.enable = true;
    shell.shellFun.enable = true;
 
    system.fonts.enable = true;
    system.graphics.hyprland.enable = true;
    system.graphics.hyprcursor.enable = true;
    system.graphics.gtk.enable = true;              
    system.ui.mako = { enable = true; theme = "rose-pine"; };
    system.xdg.portals = { enable = true; defaultPortal = "hyprland"; };

#    system.audio.mopidy.enable = true;

    shell.dev.git = { enable = true; };

    applications.term.alacritty = { enable = true; alacrittyTheme = "rose-pine"; };
    
    applications.web.firefox.enable = true;
    
    applications.social.discord = { enable = true; theme = [ "rose-pine" ]; };

    applications.rice.wofi = { enable = true; theme = "rose-pine"; };

    applications.misc.xdragon.enable = true;
    applications.misc.mangohud.enable = true;
    applications.misc.libreoffice.enable = true;
  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.11";  
 
  home.username = "skynet";
  home.homeDirectory = "/home/skynet";
  home.sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
  };

  fonts.fontconfig.enable = true;

}

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
    system.xdg.portals = { enable = true; defaultPortal = "*"; };

#    system.audio.mopidy.enable = true;

    shell.dev.git = { enable = true; };

    applications.term.alacritty = { enable = true; alacrittyTheme = "rose-pine"; };
    
    applications.web.firefox.enable = true;
    
    applications.social.discord = { enable = true; theme = [ "rose-pine" ]; };

    applications.rice.wofi = { enable = true; theme = "rose-pine"; };

    applications.misc.xdragon.enable = true;
    applications.misc.mangohud.enable = true;
  };

#  stylix.image = pkgs.fetchurl {
#    url = "https://w.wallhaven.cc/full/ox/wallhaven-ox816p.jpg";
#    sha256 = "09h08xqpkbhlsv7phjqmbd67r3nhw9b1k54i3jyznymb2zxnp0ns";
#  };

#  stylix.base16Scheme = pkgs.fetchFromGitHub {
#    owner = "edunfelt";
#    repo = "base16-rose-pine-scheme";
#    rev = "4161952824f4ede6c3eb73ef6b5f3609a76cf69a";
#    hash = "sha256-VW5M6+P3XeKU26h7QQiwicYFTczOXfpfskN9jFovxJ4=";
#  } + "/rose-pine.yaml";

#  stylix.targets.alacritty.enable = false;

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

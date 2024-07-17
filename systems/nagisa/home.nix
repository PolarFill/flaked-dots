{ inputs, outputs,  ... }:

{
  
  imports = [ 
    outputs.homeModules.default 
    inputs.arkenfox.hmModules.default
    inputs.nur.hmModules.nur
    inputs.sops-nix.homeManagerModule
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.nixvim.homeManagerModules.nixvim

    ./secrets/sops-nix.nix
  ];

  homeModules.default = {

    scripts = { enable = true; all = true; };

    shell.fish = { enable = true; theme = "rose-pine"; };

    shell.shellUtils.enable = true;
    shell.shellFun.enable = true;
 
    system.graphics.swayfx.enable = false;
    
    system.graphics.hyprland.enable = true;
    system.graphics.hyprcursor.enable = true;

    system.graphics.gtk.enable = true;              
    system.ui.mako = { enable = true; theme = "rose-pine"; };
    system.xdg.portals = { enable = true; defaultPortal = "hyprland"; };

    virtualization.distrobox = { enable = true; containers = ["arch-aur"]; nvidia = true; };

    applications.term.dev.git.enable = true;
    applications.term.utils.btop = { enable = true; theme = "rose-pine"; };
    applications.term.utils.bat = { enable = true; theme = "rose-pine"; };
    applications.term.utils.zathura = { enable = true; theme = "rose-pine"; };
    applications.term.utils.nvim = { enable = true; theme = "rose-pine"; };

    applications.flatpaks.flatpak.enable = true;
    applications.flatpaks.steam.enable = true;
    applications.flatpaks.bottles.enable = true;

    applications.term.alacritty = { enable = true; alacrittyTheme = "rose-pine"; withSixel = true; };
    
    applications.web.firefox.enable = true;
    applications.web.qbittorrent = { enable = true; theme = "rose-pine"; };
    
    applications.social.discord = { enable = true; theme = [ "rose-pine" ]; };

    applications.rice.wofi = { enable = true; theme = "rose-pine"; };
    applications.rice.swww = { enable = true; wallpaper = ./assets/frieren.jpeg; };

    applications.music.ncmpcpp.enable = true;
    applications.music.nicotine.enable = true;
    applications.music.mpd = { enable = true; scrobbler_type = "mpdscribble"; };

    applications.gaming.minecraft.prismlauncher = { enable = true; instances = [ "fabric-client-1.21" ]; };
    
    applications.misc.xdragon.enable = true;
    applications.misc.mangohud.enable = true;
    applications.misc.libreoffice.enable = true;
    applications.misc.kdenlive.enable = true;

  };

  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.11";  
 
  home.username = "skynet";
  home.homeDirectory = "/home/skynet";
  home.sessionVariables = {

      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";

      __GL_THREADED_OPTIMIZATION = "1";
      __GL_SHADER_DISK_CACHE = "1";
      __GL_SHADER_DISK_CACHE_PATH = "~/.cache/gl_cache";

  };

  fonts.fontconfig.enable = true;

}

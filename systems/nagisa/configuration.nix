{ config, pkgs, inputs, outputs, lib, ... }:

{
  imports = [
    outputs.nixosModules.default
  ];

  home-manager.backupFileExtension = "backup";

  nixosModules.default = {
    
    hardware.nvidia.proprietary.enable = true;
    hardware.storageDrives = { enable = true; userUid = "1000"; };
    os.pipewire.enable = true;
    os.fonts.enable = true;

  }; 

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = { 
      allowUnfree = true;
#      packageOverrides = pkgs: { 
#        nur = import (builtins.fetchTarball {
#          url = "https://github.com/nix-community/NUR/archive/90060445d9ee7b731c147b2caa53dc45d557bce9.tar.gz";
#	  sha256 = "0klk4f227hgsjga7qkqcs2di8y9j6b2r62w605vlgqk1fc7v3x8k";
#	}) { inherit pkgs; }; };
    };
  };

  # Add flake inputs as registrys for use on nix3 shell
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
 
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    substituters = [
        "https://hyprland.cachix.org"    
    ];
    trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ inputs.hyprland-portal.packages.${pkgs.system}.xdg-desktop-portal-hyprland ];
  };

#  services.flatpak = {
#    enable = true;
#    remotes = [ { name = "flathub"; location = "https://dl.flathub.org/repo/flathub.flatpakrepo"; } ];
#    packages = [ { appId = "com.valvesoftware.Steam"; origin = "flathub-beta"; } ]
#  };

  services.flatpak.enable = true;

  security.sudo.enable = false;
  security.doas.enable = true;
  security.doas.extraRules = [{
      users = ["skynet"];
      keepEnv = true;
      persist = true;
  }];
  
#  security.rtkit.enable = true;
  
  networking.networkmanager.enable = true;
  networking.hostName = "nagisa";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  console.keyMap = "br-abnt2";

  users.users.skynet = {
    isNormalUser = true;
    initialPassword = "123456";
    description = "Main user";
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
     neovim 
     doas
     git
  ];

  system.stateVersion = "23.11";
}

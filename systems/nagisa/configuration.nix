{ config, pkgs, inputs, outputs, lib, ... }:

{
  imports = [
    outputs.nixosModules.default
  ];

  home-manager.backupFileExtension = "backup";

  nixosModules.default = {
    
    hardware.nvidia.proprietary = { enable = true; withUnlocks = true; };
    hardware.storageDrives = { enable = true; userUid = "1000"; };
    hardware.microcode = { enable = true; cpu = "amd"; };

    os.pipewire.enable = true;
    os.fonts.enable = true;
    
    system.localization = { enable = true; extraLocale = "pt_BR"; };
    
    applications.management.doas = { enable = true; users = [ "skynet" ]; };
    applications.misc.sunshine.enable = true;

  }; 

  nixpkgs = {
    overlays = [
      inputs.nvidia-patch.overlays.default
#      outputs.overlays.additions
#      outputs.overlays.modifications
    ];
    config = { 
      allowUnfree = true;
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

  services.flatpak.enable = true;

  networking.networkmanager.enable = true;
  networking.hostName = "nagisa";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

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

  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}

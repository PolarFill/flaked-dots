{ pkgs, inputs, outputs, lib, ... }:

{
  imports = [
    outputs.nixosModules.default
    outputs.nixosModules.nagisa
    inputs.sops-nix.nixosModules.sops

    ./secrets/sops-nix-sys.nix
  ];

  home-manager.backupFileExtension = "backup";

  nixosModules.default = {
    
    hardware.nvidia.proprietary = { enable = false; withUnlocks = false; };
    hardware.nvidia.nouveau.enable = true;
    hardware.storageDrives = { enable = true; userUid = "1000"; };
    hardware.microcode = { enable = true; cpu = "amd"; };

    os.network.lokinet.enable = false;
    os.pipewire.enable = true;
    os.fonts.enable = true;

    system.network.nameservers = { enable = true; protocol = "dnscrypt2"; servers = ["quad9" "opennic"]; };
    system.network.ssh = { enable = true; secrets = true; };
    system.network.wireless.enable = false;
    system.virtualisation.single-gpu.enable = true;
    system.virtualisation.virtualisation.enable = true;
    system.localization = { enable = true; extraLocale = "pt_BR"; };
    system.kernel = { enable = true; kernel = "latest-libre"; };

    applications.management.doas = { enable = true; users = [ "skynet" ]; };
    applications.misc.sunshine.enable = true;

  };

  nixosModules.nagisa = {
    
    os.xdph.enable = true;
    os.nix-config.enable = true;

  };

  services.flatpak.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  users.users.skynet = {
    isNormalUser = true;
    initialPassword = "123456";
    description = "Main user";
    extraGroups = [ "networkmanager" "wheel" "gamemode" "libvirt" ];
    packages = [];
  };

  environment.systemPackages = with pkgs; [
     neovim 
     doas
     git
     devenv
  ];

  networking.hostName = "nagisa";
  networking.firewall.enable = false;

  system.stateVersion = "23.11";
}

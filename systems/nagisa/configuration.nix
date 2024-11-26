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
    
    hardware.nvidia.proprietary = { enable = true; withUnlocks = false; branch = "stable"; };
    hardware.nvidia.nouveau.enable = false;
    hardware.storageDrives = { enable = true; userUid = "1000"; };
    hardware.microcode = { enable = true; cpu = "amd"; };

    os.network.lokinet.enable = false;
    os.network.tor = { enable = true; torClient.enable = true; };
    os.network.i2p = { enable = true; proxies = { socks = true; http = true; }; };
    os.pipewire.enable = true;
    os.fonts.enable = true;

    system.network.nameservers = { 
      enable = true; 
      protocols = [ "anonymous-dnscrypt2" ]; 
      custom_protocols = { 
	ignore_server_list = true; 
	relays = [ "anon-cs-brazil" ];
	extra_relays = [ { server_name = "anon-cs-*"; via = [ "dnscrypt.pt-anon-*" ]; } ];
      }; 
    };

    system.network.ssh = { enable = true; secrets = true; };
    system.network.wireless.enable = false;
    system.virtualisation.virtualisation = { enable = true; active_domains = [ "whonix" ]; verbose = true; }; 
    system.localization = { enable = true; extraLocale = "pt_BR"; };
    system.kernel = { enable = true; kernel = "latest-libre"; };
    system.oom-killer = { enable = true; prefs = { prefer = "^nixos-rebuild$"; avoid = "firefox"; }; };

    applications.management.doas = { enable = true; users = [ "skynet" ]; };
    applications.misc.sunshine.enable = true;
    applications.misc.ns-usbloader.enable = true;

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

  programs.nix-ld.enable = true;

  # TODO: Make container module to transfer this piece of code there :p
  virtualisation = {
    podman = {
      defaultNetwork.settings = {
	dns_enabled = true;
      };
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
    };
  };

  system.stateVersion = "23.11";
}

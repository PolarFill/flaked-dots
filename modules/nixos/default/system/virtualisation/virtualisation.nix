{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.virtualisation.virtualisation;
  in {
    options.nixosModules.default.system.virtualisation.virtualisation = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Sets up some virt stuff";
      };

      manager = lib.options.mkOption {
	default = "virt-manager";
	type = lib.types.str;
	description = "Chooses the virtualisation manager";
      };

      nvidia = lib.options.mkOption {
	default = false;
	type = lib.types.bool;
	description = "Enables gpu-accelerated containers for nvidia";
      };

      active_domains = lib.options.mkOption {
	default = [""];
	type = lib.types.listOf lib.types.str;
	description = "Set the active domains";
      };

      verbose = lib.options.mkOption {
	default = false;
	type = lib.types.bool;
	description = "Makes nixvirt output logs during activation";
      };

      
    };

  config = lib.mkIf cfg.enable {

    hardware.nvidia-container-toolkit.enable = cfg.nvidia;

    virtualisation = {
      spiceUSBRedirection.enable = true;
    };

    programs.virt-manager.enable = lib.mkIf (cfg.manager == "virt-manager") true;

    virtualisation.libvirt = {
      enable = true;
      verbose = cfg.verbose;
      connections."qemu:///system" = {
	domains = [
	  { definition = ./assets/domains/Whonix-Workstation.xml; active = ( builtins.elem "whonix" cfg.active_domains ); }
	  { definition = ./assets/domains/Whonix-Gateway.xml; active = ( builtins.elem "whonix" cfg.active_domains ); }
	];
	networks = [
	  { definition = ./assets/networks/Whonix_internal_network.xml; active = ( builtins.elem "whonix" cfg.active_domains ); }
	  { definition = ./assets/networks/Whonix_external_network.xml; active = ( builtins.elem "whonix" cfg.active_domains ); }
	];
      };
    };

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
	package = pkgs.qemu_kvm;
	runAsRoot = true;
	swtpm.enable = true;
	ovmf = {
	  enable = true;
	  packages = [pkgs.OVMFFull.fd];
	};
	verbatimConfig = ''
	  nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
	'';
      };
    };

    environment.etc = {
      "ovmf/edk2-x86_64-secure-code.fd" = {
	source = config.virtualisation.libvirtd.qemu.package
	  + "/share/qemu/edk2-x86_64-secure-code.fd";
      };

      "ovmf/edk2-i386-vars.fd" = {
	source = config.virtualisation.libvirtd.qemu.package
	  + "/share/qemu/edk2-i386-vars.fd";
      };
    };

  };
}

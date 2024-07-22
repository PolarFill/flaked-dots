{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.virtualisation.single-gpu;
  in {
    options.nixosModules.default.system.virtualisation.single-gpu = {

      enable = lib.options.mkEnableOption {
        default = false;
        type = lib.types.bool;
        description = "Sets up some virt stuff";
      };

      cpu = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets cpu-specific kernel params";
      };

      user = lib.options.mkOption {
        default = "skynet";
	type = lib.types.nullOr lib.types.str;
	description = "Sets the user in qemu verbatimConfig";
      };

      gpu_video = lib.options.mkOption {
        default = "pci_0000_01_00_0";
	type = lib.types.nullOr lib.types.str;
	description = "Current gpu video iommu id";
      };

      gpu_audio = lib.options.mkOption {
        default = "pci_0000_01_00_1";
	type = lib.types.nullOr lib.types.str;
	description = "Current gpu audio iommu id";
      };
    };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.dmidecode
    ];

    boot.kernelParams = lib.mkMerge [
      ( lib.mkIf (cfg.cpu == "amd") [ "amd_iommu=on" "video=efifb:off" ] )
      ( lib.mkIf (cfg.cpu == "intel") [ "intel_iommu=on" ] )
      [ "iommu=pt" "kvm.ignore_msrs=1" "vfio_iommu_type1.allow_unsafe_interrupts=1" ] 
    ];

    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      qemu = {
        runAsRoot = true;
	ovmf.enable = true;
	verbatimConfig = ''
          user = "${cfg.user}"
	  group = "users"
	  namespaces = []
	'';
      };
      hooks.qemu = {
        "AAA_WIN_HOOK" = lib.getExe ( # name-based ordering
          pkgs.writeShellApplication {
            name = "qemu-hook";
	    runtimeInputs = [
              pkgs.libvirt
	      pkgs.systemd
	      pkgs.kmod
	    ];
	    text = ''
	      set -x

	      GUEST_NAME="$1"
              OPERATION="$2"

              if [ "$GUEST_NAME" == "win10" ]; then
		if [ "$OPERATION" == "prepare" ]; then

	          # Unbind efi framebuffer
		  # echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/unbind

		  # Unbind consoles
		  # echo 0 > /sys/class/vtconsole/vtcon0/bind
		  # echo 0 > /sys/class/vtconsole/vtcon1/bind

		  # Un-bind driver
		  modprobe -r -a nvidia_uvm nvidia_drm nvidia nvidia_modeset i2c_nvidia_gpu

		  # Detach GPU
		  virsh nodedev-detach ${cfg.gpu_video}
		  virsh nodedev-detach ${cfg.gpu_audio} 
		  virsh nodedev-detach pci_0000_01_00_2
		  virsh nodedev-detach pci_0000_01_00_3
		  virsh nodedev-detach pci_0001_05_00_0

		  # Load the vfio module
		  modprobe -a vfio_pci 

		  # Set allowed CPUs
		  #systemctl set-property --runtime -- user.slice AllowedCPUs=8-11
		  #systemctl set-property --runtime -- system.slice AllowedCPUs=8-11
		  #systemctl set-property --runtime -- init.scope AllowedCPUs=8-11
		elif [ "$OPERATION" == "release" ]; then
		  # Allow all CPUs
		  #systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
		  #systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
		  #systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
	
		  # Rebind consoles
		  # echo 1 > /sys/class/vtconsole/vtcon0/bind
		  # echo 1 > /sys/class/vtconsole/vtcon1/bind
		
		  # Unload vfio module
		  modprobe -r vfio-pci

		  # Re-bind efi framebuffer
		  # echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind

		  # Re-attach GPU
		  virsh nodedev-reattach ${cfg.gpu_video}
		  virsh nodedev-reattach ${cfg.gpu_audio} 
		  virsh nodedev-reattach pci_0000_01_00_2 
		  virsh nodedev-reattach pci_0000_01_00_3
		  virsh nodedev-reaatach pci_0001_05_00_0

		  # Re-bind Driver
		  modprobe -a nvidia_uvm nvidia_drm nvidia nvidia_modeset i2c_nvidia_gpu
		fi
	      fi
	    '';
	  }
	);
      };
    };

/*
    virtualisation.libvirt = {
      enable = true;
      connections."qemu:///system" = {
	domains = [
	  { 
	    definition = ./domains/win10-passthrough.xml; 
	    active = if ( builtins.elem "win10-passthrough" cfg.active-domains ) then true else false; 
	  }
	];	
      };
    };
*/
  };
}

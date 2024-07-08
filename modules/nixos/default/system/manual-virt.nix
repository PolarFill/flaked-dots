{ config, lib, pkgs, ... }:

  let
    cfg = config.nixosModules.default.system.manual-virt;
  in {
    options.nixosModules.default.system.manual-virt = {

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
	description = "Sets the use in qemu verbatimConfig";
      };

      gpu_video = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets the use in qemu verbatimConfig";
      };

      gpu_audio = lib.options.mkOption {
        default = null;
	type = lib.types.nullOr lib.types.str;
	description = "Sets the use in qemu verbatimConfig";
      };
    };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.dmidecode
    ];

    boot.kernelParams = lib.mkMerge [
      ( lib.mkIf (cfg.cpu == "amd") [ "amd_iommu=on" "video=efifb:off" ] )
      ( lib.mkIf (cfg.cpu == "intel") [ "intel_iommu=on" ] )
      ( [ "iommu=pt" "kvm.ignore_msrs=1" "vfio_iommu_type1.allow_unsafe_interrupts=1" ] )
    ];

    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      extraConfig = ''
        unix_sock_group = "libvirt"
	unix_sock_rw_perms = "0770"
	log_filters="3:qemu 1:libvirt"
	log_outputs="2:file:/var/log/libvirt/libvirtd.log"
      '';
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
	      GUEST_NAME="$1"
              OPERATION="$2"

              if [ "$GUEST_NAME" != "Windows" ]; then
                exit 0
              elif [ "$OPERATION" == "prepare" ]; then
                # Stop display-manager
                systemctl stop display-manager.service

                # Un-bind driver
                modprobe -r -a nvidia_uvm nvidia_drm nvidia nvidia_modeset

                # Detach GPU
                virsh nodedev-detach pci_0000_01_00_0
                virsh nodedev-detach pci_0000_01_00_1

                # Set allowed CPUs
                #systemctl set-property --runtime -- user.slice AllowedCPUs=8-11
                #systemctl set-property --runtime -- system.slice AllowedCPUs=8-11
                #systemctl set-property --runtime -- init.scope AllowedCPUs=8-11
              elif [ "$OPERATION" == "release" ]; then
                # Allow all CPUs
                #systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
                #systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
                #systemctl set-property --runtime -- init.scope AllowedCPUs=0-31

                # Re-attach GPU
                virsh nodedev-reattach pci_0000_01_00_0
                virsh nodedev-reattach pci_0000_01_00_1

                # Re-bind Driver
                modprobe -a nvidia_uvm nvidia_drm nvidia nvidia_modeset

                # Restart display-manager
                systemctl start display-manager.service
              else
               exit 0
              fi
	    '';
	  }
	);
      };
    };

  };
}

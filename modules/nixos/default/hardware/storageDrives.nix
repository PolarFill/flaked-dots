# THIS FILE CONTAINS USER-SPECIFIC CODE FOR NOW
# USE THIS AS A TEMPLATE ONLY, 

{ config, lib, ... }:

let
  cfg = config.nixosModules.default.hardware.storageDrives;
in {
  options.nixosModules.default.hardware.storageDrives = {

     enable = lib.options.mkEnableOption {
       default = false;
       type = lib.types.bool;
       description = "Storage driver mounter";
     };

     userUid = lib.options.mkOption {
       default = "";
       type = lib.types.str;
       description = "User uid to mount some drives as rw";
     };
   };

config = lib.mkIf cfg.enable {

  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/mnt/Ares" = {
    device = "/dev/disk/by-uuid/1220FDD720FDC1B1";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=${cfg.userUid}" "nofail" ];
  };

  fileSystems."/mnt/Zeus" = {
    device = "/dev/disk/by-uuid/56A8EBD8A8EBB521";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=${cfg.userUid}" "nofail" ];
  };

  fileSystems."/" = {
    options = [ "compress=zstd:5" ];
  };

};
}

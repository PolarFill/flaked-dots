{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.homeModules.default.applications.misc.kdenlive;
  in {
    options.homeModules.default.applications.misc.kdenlive = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Video editor!!!!";
      };
    };

  config = lib.mkIf cfg.enable {   

    home.packages = with pkgs; [
      (pkgs.python312.withPackages (python-packages: [ python-packages.pip python-packages.virtualenv python-packages.setuptools python-packages.pipx]))
      pkgs.ffmpeg
      pkgs.kdenlive
      pkgs.glaxnimate
    ];

    home.sessionPath = [
      ".local/bin"
    ];

  };
}


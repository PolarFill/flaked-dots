{ inputs, pkgs, lib, config, ... }:

  let
    cfg = config.nixosModules.default.applications.steam;
  in {
    options.nixosModules.default.applications.steam = {
      enable = lib.options.mkEnableOption {
        default = false;
	type = lib.types.boolean;
        description = "Enables steam";
      };
    };

  config = lib.mkIf cfg.enable {   

    environment.systemPackages = [
      pkgs.gamemode
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
	pkgs.luxtorpeda
      ];
      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
	];
      };
    };

    programs.gamemode.settings = {
      enable = true;
      enableRenice = true;

      settings = {
        custom = {
          start = "nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'";
	  end = "nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=0'";
	};
	general = {
          desiredgov = "performance";
	  igpu_desiredgov = "powersave";
	  softrealtime = "auto";
	  renice = 10;
	};
      };
    };
  };
}


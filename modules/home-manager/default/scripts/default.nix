# Little nix module to include scripts in path automatically

{ config, lib, ... }:

let
  cfg = config.homeModules.default.scripts;
  scriptDirAttr = builtins.readDir ./scripts;
in {
  options.homeModules.default.scripts = {

    enable = lib.options.mkEnableOption {
      default = false;
      type = lib.types.boolean;
      description = "Enables some shell scripts (mainly for fish)";
    };

    all = lib.options.mkEnableOption {
      default = false;
      type = lib.types.boolean;
      description = "Enables all scripts found in this folder";
    };
    
    scripts = lib.options.mkOption {
      default = false;
      type = lib.types.listOf lib.types.str;
      description = "Which scripts to enable. Ignored if \"all\" option is set.";
    };
  };

  config = lib.mkIf cfg.enable {

    home.sessionPath = 
      
      if cfg.all
      then lib.attrsets.mapAttrsToList ( name: value: "${./scripts/${name}}" ) scriptDirAttr # + [ "${./scripts}" ]
      else lib.lists.concatMap (x: ["${./scripts/${x}}"] ) cfg.scripts;
    
  };
}


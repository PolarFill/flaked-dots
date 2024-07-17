{ lib, config, ... }:
{
/*
let
  mods_path = ".local/share/PrismLauncher/instances/fabric-client-1.21/.minecraft/mods";
  config_path = ".local/share/PrismLauncher/instances/fabric-client-1.21/.minecraft/config";
in {
  config = { 
*/
    home.file.".local/share/PrismLauncher/instances/fabric-client-1.21/.minecraft/config/modernfix-mixins.properties".text = "mixin.perf.dynamic_resources=true"; 
/*
    ( 
      lib.fetchzip { 
        name = "fabric-client-1_21-mods";
	url = "https://www.dropbox.com/scl/fi/ftodijevpgcvtapblizxf/mods.zip?rlkey=w8mmwpbknxybrs9fxfameud87&st=8vn8uc5v&dl=1";
	hash = "sha256-10fgh3lnrfilkywq4m0gxlma3q5fi8qmzph7an0r3ywgg54gnvvc";
	postFetch = "ln -s $src ${config.home.homeDirectory}/${mods_path}";
      }
    )
*/
#  };
}

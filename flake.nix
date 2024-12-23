{
    description = " Main config file ";

    inputs = {
        
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
	home-manager = {
            url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
	};

        arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
	
	nur.url = "github:nix-community/NUR";
	
	chaotic-cx = {
          url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
 
        nvidia-patch.url = "github:icewind1991/nvidia-patch-nixos";  
        nvidia-patch.inputs.nixpkgs.follows = "nixpkgs";

	sops-nix.url = "github:Mic92/sops-nix";

        nix-flatpak.url = "github:GermanBread/declarative-flatpak/stable-v3";

        nixvirt.url = "github:AshleyYakeley/NixVirt";
	nixvirt.inputs.nixpkgs.follows = "nixpkgs";

        nixvim = {
          url = "github:nix-community/nixvim";
	  inputs.nixpkgs.follows = "nixpkgs";
	};  

	ucodenix.url = "github:e-tho/ucodenix";

        hyprland.url = "github:hyprwm/hyprland?submodules=1";
	
	hyprland-contrib = {
          url = "github:hyprwm/contrib";
          inputs.nixpkgs.follows = "nixpkgs";
        };    

#        hyprland-plugins = {
#          url = "github:hyprwm/hyprland-plugins";
#	  inputs.hyprland.follows = "hyprland";
#	};

#	hyprland-virtual-desktops = {
#          url = "github:levnikmyskin/hyprland-virtual-desktops";
#	  inputs.nixpkgs.follows = "hyprland";
#	};

};

    outputs = { self, nixpkgs, home-manager, chaotic-cx, nur, nix-flatpak, nixvirt, ... } @ inputs:

    let

      inherit (self) outputs;
      systems = [ "x86_64-linux" ];                    # Only x86_64 for now
      withAllSystems = nixpkgs.lib.genAttrs systems;   # Will gen attrs for each specified system

      nagisaSysPath = "${self}/systems/nagisa";

    in {
   
      pkgs = withAllSystems ( system: import ./custom/pkgs nixpkgs.legacyPackages.${system} ); # Access custom pkgs (if any)
      overlays = import ./custom/overlays { inherit inputs; };
      formatter = withAllSystems ( system: nixpkgs.legacyPackages.${system}.alejandra );       # Not using currently, keeping it just in case
      
      homeModules.default = "${self}/modules/home-manager/default";
      nixosModules.default = "${self}/modules/nixos/default";
      nixosModules.nagisa = "${self}/modules/nixos/nagisa";

      nixosConfigurations = {
        
	nagisa = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
	    modules = [
                "${nagisaSysPath}/configuration.nix"
		"${nagisaSysPath}/hardware-configuration.nix"
                nur.modules.nixos.default
		chaotic-cx.nixosModules.default
		nix-flatpak.nixosModules.declarative-flatpak
		nixvirt.nixosModules.default
		home-manager.nixosModules.home-manager {
                  home-manager = {
                      useGlobalPkgs = true;
		      useUserPackages = true;
		      extraSpecialArgs = { inherit inputs outputs; };
		      users = { skynet = import "${nagisaSysPath}/home.nix"; };
		  }; 
		}
	      ];
	    };
          };
        };
}

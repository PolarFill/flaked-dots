{
    description = " Main config file ";

    inputs = {
        
	nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
	home-manager = {
            url = "github:nix-community/home-manager";
	    inputs.nixpkgs.follows = "nixpkgs";
	};

        hyprland.url = "github:hyprwm/Hyprland";
	
	hyprland-contrib = {
          url = "github:hyprwm/contrib";
          inputs.nixpkgs.follows = "nixpkgs";
        };      
        hyprkeys = {
          url = "github:hyprland-community/hyprkeys";
          inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-portal = {
          url = "github:hyprwm/xdg-desktop-portal-hyprland";
	  inputs.nixpkgs.follows = "nixpkgs";
	};

        stylix.url = "github:danth/stylix";
        arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
	nur.url = "github:nix-community/NUR";

};

    outputs = { self, nixpkgs, home-manager, stylix, nur, ... } @ inputs:

    let

      inherit (self) outputs;
      systems = [ "x86_64-linux" ];                    # Only x86_64 for now
      withAllSystems = nixpkgs.lib.genAttrs systems;   # Will gen attrs for each specified system

      stylix.homeManagerIntegration.followSystem = false;
      
      nagisaSysPath = "${self}/systems/nagisa";

    in {
   
      customPkgs = withAllSystems ( system: import ./overlays/pkgs nixpkgs.legacyPackages.${system} ); # Access custom pkgs (if any)
      formatter = withAllSystems ( system: nixpkgs.legacyPackages.${system}.alejandra );      # Not using currently, keeping it just in case

      overlays = import ./overlays { inherit inputs; };
      homeModules.default = "${self}/modules/home-manager/default";
      nixosModules.default = "${self}/modules/nixos/default";

      nixosConfigurations = {
        
	nagisa = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
	    modules = [
                "${nagisaSysPath}/configuration.nix"
		"${nagisaSysPath}/hardware-configuration.nix"
                nur.nixosModules.nur
		#stylix.nixosModules.stylix
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

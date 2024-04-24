{ inputs, ... }:

{
  additions = final: _prev: import ./pkgs { pkgs = final; }; # Import custom pkgs to overlay additions

  modifications = final: prev: {


  };

}

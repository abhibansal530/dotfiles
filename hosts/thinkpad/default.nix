{ home-manager, inputs, nixpkgs, overlays, ... }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    home-manager.nixosModules.home-manager
    nixpkgs.nixosModules.notDetected

    {
      # Home-manager module.
      home-manager = {
        # Use system config's 'pkgs' argument in home manager.
        useGlobalPkgs = true;

        # To enable installation of user packages through `users.<user>.packages`.` option.
        useUserPackages = true;

        # User config.
        users.abhishek = import ../../users/abhishek;
      };

      nix = {
        # Default Nix expression search path, used to lookup for paths in angle brackets (eg. <nixpkgs>).
        nixPath = [
          "nixpkgs=${nixpkgs}"
          "home-manager=${home-manager}"
        ];

        # Nix package instance to use througout the system.
        package = nixpkgs.legacyPackages."${system}".nixFlakes;

        # System-wide flake registry.
        # registry = {};

        # Additional text appended to nix.conf.
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      };

      nixpkgs = {
        inherit overlays;
        config = {
          allowUnfree = true;
        };
      };
    }

    # NixOS module.
    ./configuration.nix
  ];

  specialArgs = { inherit inputs; };
}

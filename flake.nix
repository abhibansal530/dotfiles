{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Use above version of nixpkgs
    };

    emacs.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/NUR";

    # Nixpkgs branches
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager, ...} @ inputs:
  with nixpkgs.lib;
  let
    system = "x86_64-linux";
    filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;

    importNixFiles = path: (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
      (filterAttrs filterNixFiles (builtins.readDir path)))) import;

    overlays = with inputs; [
      (final: _:
        let
          config = {
            allowUnfree = true;
          };
          system = final.system;
        in
        {
          /*
            Nixpkgs branches

            One can access these branches like so:

            `pkgs.stable.mpd'
            `pkgs.master.linuxPackages_xanmod'
          */
          master = import master { inherit config system; };
          unstable = import unstable { inherit config system; };
          stable = import stable { inherit config system; };
        })

      # Overlays provided by inputs.
      emacs.overlay
      nur.overlay
    ]
    # Overlays from ./overlays directory.
    ++ (importNixFiles ./overlays);

    # Customize nixpkgs to use.
    myPkgs = import inputs.nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    myLib = import ./lib {
      inherit inputs home-manager;
      nixpkgs = myPkgs;
    };

    inherit (myLib) mkHomeConfig mkHost;

  in
  {
    nixosConfigurations = {
      zephyrus = mkHost {
        inherit system;
        hostName = "zephyrus";
        hostUserName = "abhi";
        hostConfig = import ./hosts/zephyrus/configuration.nix;
      };

      #thinkpad = mkHost {
      #  inherit system;
      #  hostConfig = {};
      #};
    };
  };
}

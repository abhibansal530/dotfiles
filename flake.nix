{
  description = "My NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs.url = "github:nix-community/emacs-overlay";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, ...} @ inputs:
  let
    system = "x86_64-linux";
    overlays = with inputs; [
      # Overlays provided by inputs
      emacs.overlay
      nur.overlay
    ];
  in
  {
    nixosConfigurations.zephyrus = import ./hosts/zephyrus {
      inherit home-manager inputs nixpkgs overlays;
    };
  };
}

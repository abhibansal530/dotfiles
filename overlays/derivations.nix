# This file contains custom derivations.
# Ref. : https://github.com/fortuneteller2k/nix-config/blob/master/overlays/derivations.nix
#
# NOTE: Corresponding derivations reside in a top level folder instead of a subfolder
# as we import all 'nix' files from overlay dir in flake.nix

final: prev: {
  inherit (prev.callPackages ../derivations/openvpn.nix { })
   openvpn_aws;
}

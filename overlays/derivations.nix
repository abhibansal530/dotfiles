final: prev: {
  inherit (prev.callPackages ../derivations/openvpn.nix { })
   openvpn;
}

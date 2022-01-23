{ inputs, nixpkgs, home-manager, ... }:

with builtins;
{
  mkHomeConfig = {system}: home-manager.lib.homeManagerConfiguration {
    # TODO
  };

  # Args :
  # system : System for which we are building this host.
  # hostName : Host name.
  # hostUserName : User name to configure for this host.
  # hostConfig : Host specific NixOS module for this host.
  mkHost = {system, hostName, hostUserName, hostConfig}:
    let commonModule = import ../common.nix {
          inherit inputs system nixpkgs hostName hostUserName;
        };

        validations = {
          config = {
            assertions = [
              {
                assertion = isString hostName && hostName != "";
                message = "Host name is empty.";
              }
              {
                assertion = isString hostUserName && hostUserName != "";
                message = "Host user name is empty.";
              }
            ];
          };
        };

    in inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    # Arguments to pass to all modules.
    # TODO: Clarify how this works.
    specialArgs = { inherit system inputs; };

    # Modules used to build final configuration.nix.
    modules = [
      # Validations on user input.
      validations

      # External modules used.
      home-manager.nixosModules.home-manager

      # Any common config goes here.
      commonModule

      # Host specific config.
      hostConfig

      {
        # Home manager module config.
        home-manager = {
          # Use system config's 'pkgs' argument in home manager.
          useGlobalPkgs = true;

          # To enable installation of user packages through `users.<user>.packages`.` option.
          useUserPackages = true;

          # User config.
          #users.abhi = import ../users/abhi;
          users.${hostUserName} = import ../users/${hostUserName};
        };
      }
    ];
  };
}

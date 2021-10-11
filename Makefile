nixos:
	sudo nixos-rebuild switch --flake .#

freeupboot:
	# Delete all but the last few generations
	sudo nix-env -p /nix/var/nix/profiles/system --delete-generations +3
	sudo nixos-rebuild boot --flake .#

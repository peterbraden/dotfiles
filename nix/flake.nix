{
  description = "My dev setup and easy machine conf.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixos-generators = {
    url = "github:nix-community/nixos-generators";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, nixos-generators, ... }: {
    /*
    Hemera is a developer machine, for running in a VM.
    We generate it as an iso, for booting in UTM or similar.
    */
    packages.aarch64-linux.hemera-iso = nixos-generators.nixosGenerate {
      system = "aarch64-linux";
      format = "iso";
      modules = [
        ./common/packages.nix
        ./common/users.nix
        ./common/ssh.nix
        ./hemera/hemera.nix
      ];
    };

    /*
    * Installer is an iso for an installer USB disk.
    packages.aarch64-linux.installer-iso = nixos-generators.nixosGenerate {
      system = "aarch64-linux";
      format = "install-iso";
      modules = [
        ./common/packages.nix
        ./common/users.nix
        ./common/ssh.nix
      ];
    };
    */
  };
}

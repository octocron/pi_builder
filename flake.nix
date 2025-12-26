{
  description = "NixOS configuration for Raspberry Pi 4 | 400 | 500+";

  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    megavim.url = "git+ssh://gitlab.com/megacron/megavim?ref=nixvim";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      disko,
      home-manager,
      megavim,
      nixpkgs,
      nixos-hardware,
      nixos-generators,
      self,
      sops-nix,
      ...
    }:
    {
      # NixOS configurations for each host
      nixosConfigurations = {
        ironhide = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/ironhide/default.nix
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        lockdown = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/lockdown/default.nix
            disko.nixosModules.disko
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        superion = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/superion/default.nix
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        whirl = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./hosts/whirl/default.nix
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
      };

      # Images using nixos-generators (for SD card flashing)
      packages = {
        aarch64-linux = {
          whirl-sd-image = nixos-generators.nixosGenerate {
            system = "aarch64-linux";
            modules = [
              ./hosts/whirl/default.nix
              megavim.nixosModules.default
              sops-nix.nixosModules.sops
            ];
            format = "sd-aarch64";
          };
        };
      };
    };
}

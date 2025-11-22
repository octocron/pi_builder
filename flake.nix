{
  description = "NixOS configuration for Raspberry Pi 4 | 400 | 500";

  inputs = {
    megavim.url = "git+ssh://gitlab.com/megacron/megavim?ref=nixvim";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      megavim,
      nixpkgs,
      nixos-hardware,
      nixos-generators,
      sops-nix,
      ...
    }:
    let {
       system = "aarch64-linux";

        };
    in
    {

      # Images using nixos-generators
      images = {
        whirl = inputs.nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          modules = [
            nixos-hardware.nixosModules.raspberry-pi-5
            megavim.nixosModules.default
            ./hosts/whirl
          ];
          format = "sd-aarch64";
        };
      };
    };
}

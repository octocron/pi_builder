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

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";

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
      nixos-raspberrypi,
      nix-index-database,
      self,
      sops-nix,
      ...
    }:
    let
      system = "aarch64-linux";
      username = "megacron";
      gitUsername = "megacron";
      gitEmail = "megacron@d3c3p7.com";
      theLocale = "en_US.UTF-8";
      theTimezone = "America/New_York";
      commonSpecialArgs = {
        inherit gitEmail;
        inherit gitUsername;
        inherit inputs;
        inherit theLocale;
        inherit system;
        inherit theTimezone;
        inherit username;
      };
      personalArgs = {
        inherit gitUsername;
        inherit gitEmail;
        inherit inputs;
        inherit system;
        inherit username;
      };
    in
    {
      # NixOS configurations for each host
      nixosConfigurations = {
        # INFO: Pi400 Niri
        ironhide = nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            hostname = "ironhide";
          };
          modules = [
            ./hosts/ironhide/default.nix
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        # INFO: Pi500+ Niri
        lockdown = nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            hostname = "lockdown";
          };
          modules = [
            ./hosts/lockdown/default.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            megavim.nixosModules.default
            nix-index-database.nixosModules.nix-index
            sops-nix.nixosModules.sops
            {
              home-manager = {
                extraSpecialArgs = personalArgs // {
                  hostname = "lockdown";
                };
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users.${username}.imports = [
                  ./home.nix
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
        superion = nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            hostname = "superion";
          };
          modules = [
            ./hosts/superion/default.nix
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
          disabledModules = [ ./home/ssh.nix ];
        };
        unicron = nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            hostname = "unicron";
          };
          modules = [
            ./hosts/whirl/default.nix
            megavim.nixosModules.default
            sops-nix.nixosModules.sops
          ];
        };
        # INFO: Pi5 Headless with NVMe
        primus = nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            hostname = "primus";
          };
          modules = [
            ./hosts/primus/default.nix
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };
        # INFO: Pi5 Headless with NVMe
        rodimus = nixpkgs.lib.nixosSystem {
          specialArgs = commonSpecialArgs // {
            hostname = "rodimus";
          };
          modules = [
            ./hosts/rodimus/default.nix
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.steam-servers.satisfactory;
in {
  options.services.steam-servers.satisfactory = {
    enable = mkEnableOption "Satisfactory dedicated server";
    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically start the server on boot.";
    };
    installDir = mkOption {
      type = types.str;
      default = "/var/lib/satisfactory";
      description = "Directory where server files are installed";
    };
    user = mkOption {
      type = types.str;
      default = "steam";
      description = "User account under which the server runs";
    };
    groups = mkOption {
      type = types.str;
      default = "steam";
      description = "Group account for the server";
    };
    port = mkOption {
      type = types.int;
      default = 7777;
      description = "Game port for the server";
    };
    reliablePort = mkOption {
      type = types.int;
      default = 8888;
      description = "Reliable port for the server";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open firewall ports for server";
    };
    experimental = mkOption {
      type = types.bool;
      default = false;
      description = "Use the experimental branch of the server";
    };
  };

  config = mkIf cfg.enable {
    # Ensure steamcmd is installed
    environment.systemPackages = [pkgs.steamcmd];

    # Create Steam User & Group
    users = {
      groups.${cfg.groups} = {};
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.groups;
        home = cfg.installDir;
        createHome = true;
        description = "Satisfactory server user";
      };
    };

    # Systemd service for Satisfactory
    systemd.services.satisfactory = {
      description = "Satisfactory Dedicated Server";
      wantedBy = mkIf cfg.autoStart ["multi-user.target"];
      after = ["network-online.target"];
      requires = ["network-online.target"];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.groups;
        WorkingDirectory = cfg.installDir;
        Restart = "on-failure";
        ExecStartPre = [
          ''
            ${pkgs.steamcmd}/bin/steamcmd \
              +login anonymous \
              +force_install_dir ${cfg.installDir} \
              +app_update 1690800 ${optionalString cfg.experimental "-beta experimental"} validate \
              +quit
          ''
        ];
        ExecStart = ''
          ${pkgs.steam-run}/bin/steam-run ${cfg.installDir}/FactoryServer.sh \
            -Port=${toString cfg.port} \
            -ReliablePort=${toString cfg.reliablePort} \
            -ServerQueryIP=100.102.193.39 \
            -unattended
        '';
        # Ensure proper cleanup on stop
        ExecStop = ''
          ${pkgs.procps}/bin/pkill -SIGINT -u ${cfg.user}
        '';
        # Give the server time to shut down gracefully
        TimeoutStopSec = 300;
      };
    };

    # TODO: Setup an rsync to backup save data 🙂
  };
}

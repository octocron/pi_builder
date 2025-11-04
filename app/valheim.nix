# https://kevincox.ca/2021/02/16/valheim-dedicated-server-nixos/
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.steam-servers.valheim;
in {
  options.services.steam-servers.valheim = {
    enable = mkEnableOption "Valheim dedicated server";
    autoStart = mkOption {
      type = types.bool;
      default = false;
      description = "Automatically start the server on boot.";
    };
    installDir = mkOption {
      type = types.str;
      default = "/var/lib/valheim";
      description = "Directory where server files are installed";
    };
    user = mkOption {
      type = types.str;
      default = "valeheim";
      description = "User account under which the server runs";
    };
    groups = mkOption {
      type = types.str;
      default = "valheim";
      description = "Group account for the server";
    };
    port = mkOption {
      type = types.int;
      default = 2456;
      description = "Game port for the Satisfactory server";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      # linux64 directory is required by Valheim.
      LD_LIBRARY_PATH = "linux64:${pkgs.glibc}/lib";
      systemPackages = [pkgs.steamcmd];
    };
    # Create Valheim User & Group
    users = {
      groups.${cfg.groups} = {};
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.groups;
        home = cfg.installDir;
        createHome = true;
        description = "Valheim server user";
      };
    };

    # Systemd service for Valheim
    systemd.services.valheim = {
      description = "Valheim Dedicated Server";
      wantedBy = mkIf cfg.autoStart ["multi-user.target"];
      after = ["network-online.target"];
      requires = ["network-online.target"];
      serviceConfig = {
        User = cfg.user;
        Group = cfg.groups;
        WorkingDirectory = cfg.installDir;
        Nice = "-5";
        Restart = "on-failure";
        ExecStartPre = ''
          ${pkgs.steamcmd}/bin/steamcmd \
          	+login anonymous \
          	+force_install_dir ${cfg.installDir} \
          	+app_update 896660 \
          	+quit
        '';
        ExecStart = ''
          ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 ./valheim_server.x86_64 \
          	-name "Gooberville" \
          	-port=${toString cfg.port} \
          	-world "Dedicated" \
          	-password "YOUR PASSWORD HERE!!!" \
          	-public 1
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

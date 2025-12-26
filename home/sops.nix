# INFO: For secrets placed at home user level
{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age = {
      keyFile = "/Users/${config.home.username}/.config/sops/age/keys.txt";
      sshKeyPaths = [ ];
    };
    secrets."ssh/id_${config.networking.hostname}" = {
      path = "/Users/${config.home.username}/.ssh/id_${config.networking.hostname}";
      mode = "0600";
    };
  };
}

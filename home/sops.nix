# INFO: For secrets placed at home user level
{
  hostname,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age = {
      keyFile = "/Users/${username}/.config/sops/age/keys.txt";
      sshKeyPaths = [];
    };
    secrets."ssh/id_${hostname}" = {
      path = "/Users/${username}/.ssh/id_${hostname}";
      mode = "0600";
    };
  };
}

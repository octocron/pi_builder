# INFO: For secrets placed at system level like /etc/
{
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.sops-nix.darwinModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age = {
      keyFile = "/Users/${username}/.config/sops/age/keys.txt";
      sshKeyPaths = [];
    };
    secrets = {
      "tailscale/tskey-reusable" = {
        path = "/etc/tailscale/tskey-reusable";
        mode = "0600";
      };
    };
  };
}

# NOTE: ssh -T git@github.com
# NOTE: ssh-agent is not needed when designating an IdentityFile
{ hostname, ... }:
{
  programs.ssh = {
    enable = true;
    extraConfig = ''
      addKeysToAgent yes
      IdentityFile ~/.ssh/id_"${hostname}"
    '';
  };
}

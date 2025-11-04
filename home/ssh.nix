{hostname, ...}: {
  programs.ssh = {
    enable = true;
    extraConfig = ''
      addKeysToAgent yes
      IdentityFile ~/.ssh/id_"${hostname}"
    '';
  };
}

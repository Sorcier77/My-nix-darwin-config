{ config, ... }:

{
  # SOPS Configuration for Linux (Fedora)
  sops.secrets = {
    "git/name" = { };
    "git/email" = { };
  };

  # Template pour générer un fichier de config Git propre à partir des secrets
  sops.templates."git-config".content = ''
    [user]
      name = "${config.sops.placeholder."git/name"}"
      email = "${config.sops.placeholder."git/email"}"
  '';
}

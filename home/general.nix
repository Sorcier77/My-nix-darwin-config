{ pkgs, lib, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home.stateVersion = "24.05";

  home.sessionPath = [
    "$HOME/.nix-profile/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.local/bin"
  ];

  # Global environment variables
  home.sessionVariables = {
    # Force Java applications to render correctly in tiling window managers and Wayland
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.0";
    JDK_JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.0";
    JAVA_TOOL_OPTIONS = "-Dsun.java2d.uiScale=1.0";
  };

  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';

  home.activation.installNerdFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Linking Nerd Fonts to ~/.local/share/fonts..."
    mkdir -p $HOME/.local/share/fonts
    find $HOME/.nix-profile/share/fonts -name "*NerdFont*.ttf" -exec ln -sf {} $HOME/.local/share/fonts/ \;
    echo "Updating font cache..."
    ${pkgs.fontconfig}/bin/fc-cache -f $HOME/.local/share/fonts
  '';

  home.activation.linkDesktopApplications = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    echo "Linking Home Manager desktop files to ~/.local/share/applications..."
    mkdir -p $HOME/.local/share/applications

    # Link all desktop files from ~/.nix-profile/share/applications
    if [ -d "$HOME/.nix-profile/share/applications" ]; then
      find -L "$HOME/.nix-profile/share/applications" -name "*.desktop" -exec ln -sf {} "$HOME/.local/share/applications/" \;
    fi

    echo "Updating desktop database..."
    if command -v update-desktop-database >/dev/null; then
      update-desktop-database $HOME/.local/share/applications
    fi
  '';
}

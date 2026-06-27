{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    # =================================================================
    #  LINUX ONLY TOOLS (Specific versions or overrides)
    # =================================================================
    inputs.burpsuitepro.packages.${pkgs.stdenv.hostPlatform.system}.default
    pandoc # Document Converter
    helix # Modern Editor

    strace # System Call Tracer (Linux only)
    ltrace # Library Call Tracer (Linux only)

    # Utilities
    wl-clipboard # Wayland Clipboard Support
  ];
}

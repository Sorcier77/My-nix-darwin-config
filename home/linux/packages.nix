{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # =================================================================
    #  LINUX-SPECIFIC PACKAGES
    # =================================================================
    inputs.burpsuitepro.packages.x86_64-linux.default
    pandoc # Document Converter
    helix # Modern Editor

    # System utilities
    strace # System Call Tracer (Linux only)
    ltrace # Library Call Tracer (Linux only)
    wl-clipboard # Wayland Clipboard Support
  ];
}

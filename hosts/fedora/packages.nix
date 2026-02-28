{
  pkgs,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    # =================================================================
    #  LINUX ONLY TOOLS (Kernel/Hardware Dependent)
    # =================================================================
    # Migrated CLI/TUI Tools
    inputs.burpsuitepro.packages.${pkgs.stdenv.hostPlatform.system}.default
    pandoc # Document Converter
    helix # Modern Editor

    strace # System Call Tracer (Linux only)
    ltrace # Library Call Tracer (Linux only)
    firejail # Sandboxing (Linux only namespaces)

    # Hardware Opti
    powertop
    lm_sensors
    pciutils # lspci
    usbutils # lsusb
    intel-gpu-tools
    libva-utils
    vulkan-tools

    # Utilities
    wl-clipboard # Wayland Clipboard Support

    # Network/Mac (Specific implementations)
    macchanger
  ];
}

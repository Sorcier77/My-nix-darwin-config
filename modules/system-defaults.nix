{ pkgs, ... }:
{
  ##########################################################################
  #
  #  macOS System Defaults - Fine-tuned for better UX
  #
  ##########################################################################

  system.defaults = {
    # Dock settings
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 1.0;
      show-recents = false;
      tilesize = 70;
      orientation = "left";
      mru-spaces = false; # Don't rearrange spaces
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # List view
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    # Global macOS settings
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
      # Natural scrolling off for mice
      "com.apple.swipescrolldirection" = false;
      # Expand save and print panels by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      # Key repeat speed
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      # Disable press-and-hold for accent characters
      ApplePressAndHoldEnabled = false;
    };

    # Screenshots
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = false;
    };

    # Trackpad
    trackpad = {
      Clicking = true; # Tap to click
      TrackpadThreeFingerDrag = true;
    };

    # Menu bar
    menuExtraClock = {
      ShowAMPM = false;
      ShowDate = 1;
      ShowDayOfWeek = true;
    };
  };

  # Create Screenshots folder
  system.activationScripts.postActivation.text = ''
    mkdir -p ~/Pictures/Screenshots
  '';
}

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
      mru-spaces = true; # rearrange spaces
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
      # Natural scrolling on (Apple default)
      "com.apple.swipescrolldirection" = false;
      # Expand save and print panels by default
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      # InitialKeyRepeat = 10;
      # KeyRepeat = 1;
      # Disable press-and-hold for accent characters
      ApplePressAndHoldEnabled = false;
      
      # OpSec: Disable Siri and Telemetry
      AppleEnableSwipeNavigateWithScrolls = false;
    };

    # Custom Settings for Privacy & Anti-Forensics
    CustomSystemPreferences = {
      "com.apple.AdLib" = { allowApplePersonalizedAdvertising = false; };
      "com.apple.Siri" = {
        "UA_Enabled" = false;
        "Assistant Enabled" = false;
      };
      "com.apple.desktopservices" = {
        # Disable .DS_Store creation on network and USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
    };
  };

  networking.applicationFirewall = {
    enable = true;
    allowSigned = true;
    allowSignedApp = true;
    enableStealthMode = true;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      # Disable recently opened documents in Finder
      "FXRecentFoldersMaxCount" = 0;
    };
    "com.apple.spotlight" = {
      # Limit Spotlight indexing to exclude sensitive areas (manual config usually better)
    };
  };

  # Create Screenshots folder
  system.activationScripts.postActivation.text = ''
    mkdir -p ~/Pictures/Screenshots
  '';
}

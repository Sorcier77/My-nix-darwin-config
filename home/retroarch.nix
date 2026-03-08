{ pkgs, ... }:

{
  programs.retroarch = {
    enable = true;
    # On active les cores via des sous-modules
    cores = {
      snes9x.enable = true;
      mgba.enable = true;
      genesis-plus-gx.enable = true;
      beetle-psx-hw.enable = true;
      picodrive.enable = true;
      fbneo.enable = true;
      mame.enable = true;
      parallel-n64.enable = true;
      stella2014.enable = true;
      gambatte.enable = true;
      desmume.enable = true;
    };

    # Configuration fine de RetroArch (retroarch.cfg)
    settings = {
      # --- Interface ---
      menu_driver = "ozone"; # Interface moderne et propre
      menu_show_advanced_settings = true;
      menu_battery_level_enable = true;
      menu_core_enable = true;

      # --- Vidéo ---
      video_fullscreen = true;
      video_vsync = true;
      video_driver = "glcore"; # Compatible avec la plupart des drivers Linux/Fedora
      video_shader_delay = 0;

      # --- Audio ---
      audio_enable = true;
      audio_sync = true;

      # --- Chemins (Organisation) ---
      system_directory = "~/Documents/RetroArch/system"; # Dossier pour les BIOS
      savefile_directory = "~/Documents/RetroArch/saves"; # Sauvegardes in-game
      savestate_directory = "~/Documents/RetroArch/states"; # Savestates
      screenshot_directory = "~/Pictures/RetroArch"; # Captures d'écran
      assets_directory = "~/.config/retroarch/assets";

      # --- RetroAchievements (Cheevos) ---
      cheevos_enable = true;
      cheevos_username = "VOTRE_PSEUDO"; # REMPLACER PAR VOTRE PSEUDO
      cheevos_password = "VOTRE_PASSWORD"; # REMPLACER PAR VOTRE PASSWORD (OU API KEY)
      cheevos_hardcore_mode_enable = true; # Active le mode hardcore (pas de savestates/cheats)
      cheevos_rich_presence_enable = true; # Affiche votre activité sur le site
      cheevos_unlock_sound_enable = true; # Petit son lors d'un succès
      cheevos_verbose_enable = true; # Notifications à l'écran

      # --- Entrées & Raccourcis ---
      input_menu_toggle_gamepad_combo = 6; # L3 + R3 (Presser les deux sticks) pour le menu
      input_overlay_enable = true;
      input_autodetect_enable = true;

      # --- Performance & Divers ---
      rewind_enable = false; # Désactivé par défaut car gourmand (et inutile en Cheevos Hardcore)
      autosave_interval = 300; # Sauvegarde de la SRAM toutes les 5 minutes
      block_extract_archives = false; # Permet de lire les .zip directement
    };
  };
}

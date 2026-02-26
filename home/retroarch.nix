{ pkgs, ... }:

{
  programs.retroarch = {
    enable = true;
    # On installe les cores essentiels et performants
    cores = with pkgs.libretro; [
      snes9x          # Super Nintendo (Excellent équilibre perf/compat)
      mgba            # GameBoy Advance (Le standard)
      genesis-plus-gx # Megadrive / Master System
      beetle-psx-hw   # PlayStation 1 (Version hardware pour l'upscaling)
      picodrive       # Megadrive / 32X (Très rapide)
      fbneo           # Arcade (Neo Geo, CPS1/2/3)
      mame            # Arcade (Général)
      parallel-n64    # Nintendo 64 (Optimisé avec ParaLLEl-RDP)
      stella-2014     # Atari 2600
      gambatte        # GameBoy / GB Color
      desmume         # Nintendo DS
    ];
    
    # Configuration fine de RetroArch (retroarch.cfg)
    settings = {
      # --- Interface ---
      menu_driver = "ozone";           # Interface moderne et propre
      menu_show_advanced_settings = true;
      menu_battery_level_enable = true;
      menu_core_enable = true;
      
      # --- Vidéo ---
      video_fullscreen = true;
      video_vsync = true;
      video_driver = "glcore";         # Compatible avec la plupart des drivers Linux/Fedora
      video_shader_delay = 0;
      
      # --- Audio ---
      audio_enable = true;
      audio_sync = true;
      
      # --- Chemins (Organisation) ---
      system_directory = "~/Documents/RetroArch/system";     # Dossier pour les BIOS
      savefile_directory = "~/Documents/RetroArch/saves";    # Sauvegardes in-game
      savestate_directory = "~/Documents/RetroArch/states";  # Savestates
      screenshot_directory = "~/Pictures/RetroArch";         # Captures d'écran
      assets_directory = "~/.config/retroarch/assets";
      
      # --- RetroAchievements (Cheevos) ---
      cheevos_enable = true;
      cheevos_username = "VOTRE_PSEUDO"; # REMPLACER PAR VOTRE PSEUDO
      cheevos_password = "VOTRE_PASSWORD"; # REMPLACER PAR VOTRE PASSWORD (OU API KEY)
      cheevos_hardcore_mode_enable = true; # Active le mode hardcore (pas de savestates/cheats)
      cheevos_rich_presence_enable = true; # Affiche votre activité sur le site
      cheevos_unlock_sound_enable = true;  # Petit son lors d'un succès
      cheevos_verbose_enable = true;       # Notifications à l'écran
      
      # --- Entrées & Raccourcis ---
      input_menu_toggle_gamepad_combo = 6; # L3 + R3 (Presser les deux sticks) pour le menu
      input_overlay_enable = true;
      input_autodetect_enable = true;
      
      # --- Performance & Divers ---
      rewind_enable = false;               # Désactivé par défaut car gourmand (et inutile en Cheevos Hardcore)
      autosave_interval = 300;             # Sauvegarde de la SRAM toutes les 5 minutes
      block_extract_archives = false;      # Permet de lire les .zip directement
    };
  };
}

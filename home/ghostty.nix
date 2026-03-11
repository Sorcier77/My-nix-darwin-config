{ config, pkgs, ... }:

{
  xdg.configFile."ghostty/config".text = ''
    # --- TYPOGRAPHIE (JetBrains Mono Nerd Font) ---
    font-family = "JetBrainsMono Nerd Font"
    font-size = 13
    # Ligatures activées pour un code plus beau (ex: -> devient →)
    font-feature = ["calt", "liga", "dlig"]

    # --- DESIGN "TABS-INTEGRATED" ---
    theme = Catppuccin Mocha
    # Intègre les onglets directement dans la barre de titre (le style que vous vouliez)
    macos-titlebar-style = tabs
    macos-titlebar-proxy-icon = hidden
    
    # --- EFFET "GLASS" (Nouveauté 1.3.0) ---
    background-opacity = 0.95

    # --- CURSEUR "BEAM" (Barre fine & stylée) ---
    cursor-style = bar
    cursor-style-blink = true

    # --- FENÊTRE & ESPACE ---
    window-padding-x = 12
    window-padding-y = 12
    window-padding-balance = true
    # On cache les scrollbars pour le minimalisme total
    scrollbar = never

    # --- PRODUCTIVITÉ 1.3.0 ---
    shell-integration = zsh
    shell-integration-features = cursor,sudo
    notify-on-command-finish = unfocused
    notify-on-command-finish-action = no-bell,notify
    notify-on-command-finish-after = 30s

    # --- GESTION DES RÉPERTOIRES (1.3.0) ---
    window-inherit-working-directory = false
    tab-inherit-working-directory = true
    split-inherit-working-directory = true

    # --- RACCOURCIS CLAVIER (STABILITÉ) ---
    # Onglets et Fenêtres
    keybind = cmd+t=new_tab
    keybind = cmd+shift+w=close_tab
    keybind = cmd+w=close_tab
    keybind = cmd+shift+n=next_tab
    keybind = cmd+shift+p=previous_tab

    # Splits
    keybind = cmd+d=new_split:right
    keybind = cmd+shift+d=new_split:down
    
    # --- SYSTÈME & CONFORT ---
    macos-option-as-alt = true
    confirm-close-surface = true
  '';
}

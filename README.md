# nix-darwin Configuration

Ma configuration nix-darwin pour macOS avec home-manager. Je suis sur MacBookPro M2.

## Installation

```bash
# Première installation
darwin-rebuild switch --flake ~/.config/nix-darwin

# Mise à jour
hms  # alias pour darwin-rebuild switch
```

## Structure

```
.
├── flake.nix              # Point d'entrée principal
├── secrets.nix            # Secrets (gitignored)
├── secrets.nix.example    # Template pour secrets
├── modules/
│   ├── apps.nix           # Packages système et homebrew
│   └── system-defaults.nix # Préférences macOS
└── home/
    ├── default.nix        # Config home-manager
    ├── core.nix           # Shell, Git, CLI tools
    ├── nixvim.nix         # Configuration Neovim
    └── sublime.nix        # Configuration Sublime Text
```

## Gestion des secrets

1. Copier le template : `cp secrets.nix.example secrets.nix`
2. Éditer avec vos vraies valeurs
3. Le fichier `secrets.nix` est dans `.gitignore`

## Fonctionnalités

- **Shell moderne** : zsh + powerlevel10k + plugins
- **CLI tools** : eza, bat, ripgrep, fzf, lazygit, zoxide
- **Neovim** : Configuration via nixvim avec LSP
- **Git** : delta pour les diffs
- **Optimisations macOS** : Dock, Finder, trackpad, etc.
- **Garbage collection** : Automatique chaque dimanche
- **Binary cache** : cache.nixos.org + nix-community

## Commandes utiles

```bash
# Rebuild système
hms

# Nettoyer anciennes générations
nix-collect-garbage -d

# Voir les générations
darwin-rebuild --list-generations

# Rollback
darwin-rebuild switch --rollback

# Update flake inputs
nix flake update
```

## Packages installés

Voir `modules/apps.nix` et `home/core.nix` pour la liste complète.

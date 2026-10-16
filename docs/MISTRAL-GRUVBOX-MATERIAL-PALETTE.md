# Mistral Gruvbox Material - Color Palette

This is the unified color palette for the Mistral AI style with Gruvbox Material influences.

## Base Colors (Charbon / Dark)

| Name | Hex | Usage |
|------|-----|-------|
| **bg0** | `#1a1a1a` | Main background (charbon) |
| **bg1** | `#282828` | Slightly lighter background |
| **bg2** | `#3a3a3a` | Selection/visual background, borders |
| **bg3** | `#000000` | Pure black for contrast |

## Foreground Colors

| Name | Hex | Usage |
|------|-----|-------|
| **fg0** | `#ebdbb2` | Main foreground (Gruvbox light) |
| **fg1** | `#d4be98` | Dimmer foreground |
| **fg2** | `#a89984` | Comments, line numbers, secondary text |
| **fg3** | `#83a598` | Blue-ish foreground |

## Accent Colors (Gruvbox Material + Mistral)

| Name | Hex | Usage |
|------|-----|-------|
| **red** | `#fb4934` | Errors, deletions, critical |
| **green** | `#b8bb26` | Success, strings, additions |
| **yellow** | `#fabd2f` | Warnings, numbers |
| **blue** | `#83a598` | Info, functions |
| **purple** | `#d3869b` | Keywords, special |
| **orange** | `#ff9500` | **Mistral signature orange** - constants, operators, highlights |
| **cyan** | `#8ec07c` | Types, hints |

## Bright Variants

| Name | Hex | Usage |
|------|-----|-------|
| **bright_red** | `#fe8019` | Brighter red variant |
| **bright_orange** | `#ffa500` | Brighter orange variant |
| **bright_fg** | `#fbf1c7` | Bright foreground |

## Applied To

This palette is applied to the following components:

### Terminal & Shell
- **Zellij**: Custom `mistral-gruvbox` theme with all 16 colors
- **Tmux**: Custom styling with status bar, window borders, and terminal colors
- **Neovim (Nixvim)**: Complete `mistral-gruvbox-material` colorscheme with syntax highlighting

### Window Managers
- **Sway**: Window borders, Waybar styling, Rofi theme, and swaylock colors
- **GNOME**: GTK theme overrides and accent color

### Editors
- **Sublime Text**: Custom `Mistral-Gruvbox-Material` color scheme

## Usage in Other Configs

To use this palette in other configurations, reference these hex values:

```nix
# Example for a terminal
terminal-colors = [
  "#1a1a1a"  # black
  "#fb4934"  # red
  "#b8bb26"  # green
  "#fabd2f"  # yellow
  "#83a598"  # blue
  "#d3869b"  # magenta/purple
  "#8ec07c"  # cyan
  "#ebdbb2"  # white/foreground
  "#3a3a3a"  # bright black
  "#ff9500"  # bright red (Mistral orange)
  "#83a598"  # bright green
  "#fabd2f"  # bright yellow
  "#8ec07c"  # bright blue
  "#d3869b"  # bright magenta
  "#fb4934"  # bright cyan
  "#fbf1c7"  # bright white
];
```

## Notes

- The **orange (#ff9500)** is Mistral AI's signature color and is used as the primary accent
- **Charbon (#1a1a1a)** is the dark background that gives the "coal" feel
- The palette combines the readability of Gruvbox with the brand identity of Mistral AI
- All colors are carefully chosen to be accessible and provide good contrast

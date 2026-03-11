{ config, pkgs, ... }:

{
  xdg.configFile."aerospace/aerospace.toml".text = ''
    # --- AeroSpace Configuration (Managed by Nix) ---
    
    # Start AeroSpace at login
    start-at-login = true

    # Normalizations
    enable-normalization-flatten-containers = true
    enable-normalization-opposite-orientation-for-nested-containers = true

    # Layouts & Gaps
    accordion-padding = 30
    default-root-container-layout = 'tiles'
    default-root-container-orientation = 'auto'

    # Mouse
    on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

    # Gaps between windows
    [gaps]
    inner.horizontal = 10
    inner.vertical =   10
    outer.left =       10
    outer.bottom =     10
    outer.top =        10
    outer.right =      10

    [mode.main.binding]
    # Terminal Shortcut (Ghostty)
    alt-enter = 'exec-and-forget open -n /Applications/Ghostty.app'

    # Layout
    alt-slash = 'layout tiles horizontal vertical'
    alt-comma = 'layout accordion horizontal vertical'

    # Focus
    alt-left = 'focus left'
    alt-down = 'focus down'
    alt-up = 'focus up'
    alt-right = 'focus right'

    # Move
    alt-shift-left = 'move left'
    alt-shift-down = 'move down'
    alt-shift-up = 'move up'
    alt-shift-right = 'move right'

    # Resize
    alt-shift-minus = 'resize smart -50'
    alt-shift-equal = 'resize smart +50'

    # Workspaces
    alt-1 = 'workspace 1'
    alt-2 = 'workspace 2'
    alt-3 = 'workspace 3'
    alt-4 = 'workspace 4'
    alt-5 = 'workspace 5'
    alt-6 = 'workspace 6'
    alt-7 = 'workspace 7'
    alt-8 = 'workspace 8'
    alt-9 = 'workspace 9'
    alt-a = 'workspace A'
    alt-b = 'workspace B'
    alt-c = 'workspace C'
    alt-d = 'workspace D'
    alt-e = 'workspace E'
    alt-f = 'workspace F'
    alt-g = 'workspace G'
    alt-i = 'workspace I'
    alt-m = 'workspace M'
    alt-n = 'workspace N'
    alt-o = 'workspace O'
    alt-p = 'workspace P'
    alt-q = 'workspace Q'
    alt-r = 'workspace R'
    alt-s = 'workspace S'
    alt-t = 'workspace T'
    alt-u = 'workspace U'
    alt-v = 'workspace V'
    alt-w = 'workspace W'
    alt-x = 'workspace X'
    alt-y = 'workspace Y'
    alt-z = 'workspace Z'

    # Move node to workspace
    alt-shift-1 = 'move-node-to-workspace 1'
    alt-shift-2 = 'move-node-to-workspace 2'
    alt-shift-3 = 'move-node-to-workspace 3'
    alt-shift-4 = 'move-node-to-workspace 4'
    alt-shift-5 = 'move-node-to-workspace 5'
    alt-shift-6 = 'move-node-to-workspace 6'
    alt-shift-7 = 'move-node-to-workspace 7'
    alt-shift-8 = 'move-node-to-workspace 8'
    alt-shift-9 = 'move-node-to-workspace 9'
    alt-shift-a = 'move-node-to-workspace A'

    alt-tab = 'workspace-back-and-forth'
    alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

    # Mode Service
    alt-shift-semicolon = 'mode service'

    [mode.service.binding]
    esc = ['reload-config', 'mode main']
    r = ['flatten-workspace-tree', 'mode main'] 
    f = ['layout floating tiling', 'mode main'] 
    backspace = ['close-all-windows-but-current', 'mode main']

    alt-shift-h = ['join-with left', 'mode main']
    alt-shift-j = ['join-with down', 'mode main']
    alt-shift-k = ['join-with up', 'mode main']
    alt-shift-l = ['join-with right', 'mode main']
    alt-shift-f = 'fullscreen'
  '';
}

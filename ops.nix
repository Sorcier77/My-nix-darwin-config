{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  name = "ops-env";

  buildInputs = with pkgs; [
    # C2 & Infrastructure
    sliver
    metasploit
    terraform
    ansible
    
    # Network & Tunneling
    chisel
    # ligolo-ng (Unsupported on macOS ARM)
    proxychains-ng
    socat
    tcpdump
    tshark
    wireguard-tools
    obfs4
    
    # Recon & Scanning
    masscan
    nmap
    rustscan
    amass
    subfinder
    httpx
    nuclei
    ffuf
    
    # Data Analysis & Forensics
    ripgrep-all
    exiftool
    binwalk
    yara
    ghidra
    radare2
    frida-tools
    mitmproxy
    
    # Development & Weaponization
    zig
    nim
    pkgsCross.mingwW64.buildPackages.gcc
    upx
    go
    rustup
    python312
    python312Packages.impacket
    python312Packages.bloodhound-py
    
    # Cloud Operations
    awscli2
    azure-cli
    google-cloud-sdk
    cloudfox
    pacu
    
    # Utilities
    jq
    yq-go
    age
    rage
    sops
    rclone
  ];

  shellHook = ''
    export HISTFILE="$PWD/.ops_history"
    export HISTCONTROL=ignoredups:erasedups
    export HISTSIZE=100000
    export PS1="[ops] \u@\h:\w\$ "

    alias px='proxychains4 -q'
    
    cleanup() {
      if [ -f .ops_history ]; then
        shred -u .ops_history 2>/dev/null || rm -f .ops_history
      fi
      echo "" | pbcopy
      pkill -f proxychains 2>/dev/null
      pkill -f chisel 2>/dev/null
      pkill -f ligolo 2>/dev/null
      history -c
      exit
    }
  '';
}

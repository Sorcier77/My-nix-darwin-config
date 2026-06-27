#!/usr/bin/env bash
# Fedora Hardening Script (Professional Edition - Clean)
# Must be run with sudo

# Root check
if [ "$EUID" -ne 0 ]; then 
  echo "Error: This script must be run with sudo."
  exit 1
fi

echo "Starting system hardening..."

# 1. Purge Bloatware & Snap
echo "Purging Snap, Telemetry and GNOME bloatware..."
dnf remove -y snapd abrt* gnome-tour gnome-software rhythmbox totem cheese gnome-connections yelp >/dev/null 2>&1
rm -rf /var/cache/snapd /snap ~/snap

# 2. Services & Firewall Hardening
echo "Optimizing services and firewall..."
SERVICES_TO_DISABLE=(
    abrtd.service abrt-journal-core.service abrt-oops.service abrt-xorg.service
    avahi-daemon.service avahi-daemon.socket
    iscsid.service iscsid.socket
    nfs-client.target remote-fs.target
    ModemManager.service
    atd.service
    wsdd.service
)

for svc in "${SERVICES_TO_DISABLE[@]}"; do
    systemctl disable --now "$svc" >/dev/null 2>&1
done

# Firewall tightening
if command -v firewall-cmd >/dev/null 2>&1; then
    DEFAULT_IFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
    if firewall-cmd --get-zones | grep -q "FedoraWorkstation"; then
        [ -n "$DEFAULT_IFACE" ] && firewall-cmd --permanent --zone=FedoraWorkstation --change-interface="$DEFAULT_IFACE" >/dev/null 2>&1
        firewall-cmd --permanent --zone=FedoraWorkstation --remove-service=dhcpv6-client >/dev/null 2>&1
        firewall-cmd --reload >/dev/null 2>&1
    fi
fi

# 2. Kernel & Network Hardening (Sysctl)
echo "Applying Kernel parameters (Sysctl)..."
cat <<EOF > /etc/sysctl.d/99-hardening.conf
# Memory Hardening
kernel.randomize_va_space = 2
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.unprivileged_bpf_disabled = 1
kernel.yama.ptrace_scope = 1
kernel.perf_event_paranoid = 3
kernel.sysrq = 0
kernel.kexec_load_disabled = 1
dev.tty.ldisc_autoload = 0
net.core.bpf_jit_harden = 2

# Desktop Performance Optimization (fluidity)
vm.swappiness = 10
vm.vfs_cache_pressure = 50

# Network Performance Optimization (BBR + FQ + TCP Fast Open)
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.core.somaxconn = 1024
net.ipv4.tcp_fastopen = 3

# Wazuh FIM (File Integrity Monitoring) Performance
fs.inotify.max_user_watches = 1048576
fs.inotify.max_user_instances = 1024

# FS Hardening
fs.protected_symlinks = 1
fs.protected_hardlinks = 1
fs.protected_fifos = 2
fs.protected_regular = 2
fs.suid_dumpable = 0

# IPv4 Hardening
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.log_martians = 1

# IPv6 Hardening
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
EOF

sysctl -p /etc/sysctl.d/99-hardening.conf >/dev/null 2>&1

# 2.1 Boot Security (Optimized for performance and fluidity)
# Reverted aggressive options that degrade SSD/GPU speed and app launch times
if [ -f /etc/default/grub ]; then
    echo "Restoring optimized GRUB boot parameters..."
    # Backup
    cp /etc/default/grub /etc/default/grub.bak
    
    # Clean up and reset GRUB cmdline (forcing the modern 'xe' driver for Meteor Lake graphics)
    sed -i 's/GRUB_CMDLINE_LINUX=".*"/GRUB_CMDLINE_LINUX="rhgb quiet i915.force_probe=!7d45 xe.force_probe=7d45"/' /etc/default/grub

    if [ -d /boot/efi/EFI/fedora ]; then
        grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg >/dev/null 2>&1
    else
        grub2-mkconfig -o /boot/grub2/grub.cfg >/dev/null 2>&1
    fi
fi

# 2.2 Disable Coredumps
echo "* hard core 0" > /etc/security/limits.d/99-disable-core-dumps.conf
if [ -d /etc/systemd/coredump.conf.d ]; then
    echo -e "[Coredump]\nStorage=none" > /etc/systemd/coredump.conf.d/disable.conf
else
    echo -e "[Coredump]\nStorage=none" > /etc/systemd/coredump.conf
fi

# 2.3 SSH Hardening
if [ -f /etc/ssh/sshd_config ]; then
    echo "Securing SSH..."
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sed -i 's/^#X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
    sed -i 's/^X11Forwarding yes/X11Forwarding no/' /etc/ssh/sshd_config
    systemctl restart sshd >/dev/null 2>&1
fi

# 2.4 Filesystem Hardening (Tmpfs & Anti-Forensics) & SSD Optimization
# Optimizing root / partition to use noatime if it isn't already
if grep -q "subvol=root,compress=zstd:1 " /etc/fstab; then
    echo "Adding noatime option to root partition..."
    sed -i 's/subvol=root,compress=zstd:1 /subvol=root,compress=zstd:1,noatime /' /etc/fstab
fi

if ! grep -q "tmpfs /dev/shm" /etc/fstab; then
    echo "Securing /dev/shm, /tmp and /var/tmp..."
    echo "tmpfs /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0" >> /etc/fstab
    echo "tmpfs /tmp tmpfs defaults,nosuid,nodev 0 0" >> /etc/fstab
    echo "tmpfs /var/tmp tmpfs defaults,nosuid,nodev 0 0" >> /etc/fstab
    systemctl daemon-reload
    mount -o remount,noexec,nosuid,nodev /dev/shm 2>/dev/null
fi

# 2.5 DNS Optimization (Opportunistic DoT & DNSSEC to prevent timeouts)
if systemctl is-active systemd-resolved >/dev/null 2>&1; then
    echo "Optimizing DNS settings (Opportunistic DoT)..."
    # Clean up conflicting strict configurations
    rm -f /etc/systemd/resolved.conf.d/99-dns-over-tls.conf
    rm -f /etc/systemd/resolved.conf.d/stub-
    rm -f /etc/systemd/resolved.conf.d/stub-listener.conf
    
    mkdir -p /etc/systemd/resolved.conf.d/
    cat <<EOF > /etc/systemd/resolved.conf.d/optimization.conf
[Resolve]
DNSSEC=allow-downgrade
Cache=yes
DNSOverTLS=opportunistic
LLMNR=no
MulticastDNS=no
EOF
    systemctl restart systemd-resolved >/dev/null 2>&1
fi

# 2.6 Legal Banners
echo "Configuring legal banners /etc/issue and /etc/issue.net..."
BANNER_TEXT="WARNING: Authorized users only. All activities may be monitored and recorded."
rm -f /etc/issue /etc/issue.net
echo "$BANNER_TEXT" > /etc/issue
echo "$BANNER_TEXT" > /etc/issue.net
chmod 644 /etc/issue /etc/issue.net

# 3. MAC Randomization
echo "Enabling MAC randomization..."
cat <<EOF > /etc/NetworkManager/conf.d/00-macrandomize.conf
[device]
wifi.scan-rand-mac-address=yes
[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
EOF
systemctl reload NetworkManager >/dev/null 2>&1

# 4. Blacklist Unused Protocols
echo "Blacklisting unused network protocols..."
cat <<EOF > /etc/modprobe.d/blacklist-network.conf
install dccp /bin/true
install sctp /bin/true
install rds /bin/true
install tipc /bin/true
EOF

# 5. USBGuard Policy
if command -v usbguard >/dev/null 2>&1; then
    if [ ! -f /etc/usbguard/rules.conf ]; then
        echo "USBGuard: Generating initial policy..."
        usbguard generate-policy > /etc/usbguard/rules.conf
        chmod 600 /etc/usbguard/rules.conf
    fi
    systemctl enable --now usbguard >/dev/null 2>&1
fi

# 6. Auditd Policy
if [ -d /etc/audit/rules.d ]; then
    echo "Updating Auditd rules..."
    cat <<EOF > /etc/audit/rules.d/99-hardening.rules
-a always,exit -F path=/etc/sudoers -F perm=wa -k sudoers_changes
-a always,exit -F path=/etc/passwd -F perm=wa -k passwd_changes
-a always,exit -F path=/etc/shadow -F perm=wa -k shadow_changes
-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k setuid_exec
EOF
    chmod 600 /etc/audit/rules.d/99-hardening.rules
    if command -v augenrules >/dev/null 2>&1; then
        augenrules --load >/dev/null 2>&1
    fi
fi

# 7. SELinux Enforcing
echo "Ensuring SELinux is Enforcing..."
setenforce 1 >/dev/null 2>&1
sed -i 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/selinux/config

# 8. SUID & File Permissions Fix & Wazuh Optimization
[ -f /opt/pt/bin/updatepttp ] && chmod u-s /opt/pt/bin/updatepttp

# Restrict permissions of cron / at files if they exist (FILE-7524)
for f in /etc/crontab /etc/cron.deny /etc/at.deny; do
    if [ -f "$f" ]; then
        chmod 600 "$f"
        chown root:root "$f"
    fi
done

# Optimization: Wazuh-agent boot delay fix (Avoid blocking on network-online.target)
if [ -f /usr/lib/systemd/system/wazuh-agent.service ] || [ -f /etc/systemd/system/wazuh-agent.service ]; then
    echo "Optimizing Wazuh-agent boot..."
    cat <<EOF > /etc/systemd/system/wazuh-agent.service
[Unit]
Description=Wazuh agent
After=network.target
Wants=network.target

[Service]
Type=forking
ExecStart=/usr/bin/env /var/ossec/bin/wazuh-control start
ExecStop=/usr/bin/env /var/ossec/bin/wazuh-control stop
ExecReload=/usr/bin/env /var/ossec/bin/wazuh-control reload
KillMode=mixed
RemainAfterExit=yes
TimeoutStartSec=180s
TimeoutStopSec=180s

[Install]
WantedBy=multi-user.target
EOF
    # Clean up old override directory to prevent conflict
    rm -rf /etc/systemd/system/wazuh-agent.service.d
    systemctl daemon-reload
fi

# 9. User Environment Hardening (Umask 077)
echo "Setting Umask 077 for user environment..."
if ! grep -q "umask 077" /etc/profile; then
    echo "umask 077" >> /etc/profile
fi
if [ -f /etc/login.defs ]; then
    sed -i 's/^UMASK.*/UMASK           077/' /etc/login.defs
    # Configure password hashing rounds
    if ! grep -q "^SHA_CRYPT_MIN_ROUNDS" /etc/login.defs; then
        echo "SHA_CRYPT_MIN_ROUNDS 5000" >> /etc/login.defs
    fi
    if ! grep -q "^SHA_CRYPT_MAX_ROUNDS" /etc/login.defs; then
        echo "SHA_CRYPT_MAX_ROUNDS 10000" >> /etc/login.defs
    fi
    # Configure password aging limits
    sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs || echo "PASS_MAX_DAYS   90" >> /etc/login.defs
    sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs || echo "PASS_MIN_DAYS   1" >> /etc/login.defs
    sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs || echo "PASS_WARN_AGE   7" >> /etc/login.defs
# 2.7 Systemd Timeout Optimization (Fast Shutdown/Reboot)
echo "Optimizing systemd stop timeouts..."
mkdir -p /etc/systemd/system.conf.d/
cat <<EOF > /etc/systemd/system.conf.d/99-timeouts.conf
[Manager]
DefaultTimeoutStartSec=10s
DefaultTimeoutStopSec=10s
EOF

# 2.8 Journald Logs Limit (Save disk space & speed up queries)
echo "Limiting journald log sizes..."
mkdir -p /etc/systemd/journald.conf.d/
cat <<EOF > /etc/systemd/journald.conf.d/99-limits.conf
[Journal]
SystemMaxUse=200M
SystemMaxFileSize=50M
EOF
systemctl restart systemd-journald >/dev/null 2>&1

fi

echo "Hardening complete. Please reboot to apply all changes."

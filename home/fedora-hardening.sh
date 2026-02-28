#!/usr/bin/env bash
# Fedora Hardening Script (DGSE/Professional)
# Must be run with sudo

# 1. Services Hardening
systemctl disable --now abrtd.service abrt-journal-core.service abrt-oops.service abrt-xorg.service
systemctl disable --now avahi-daemon.service avahi-daemon.socket
systemctl disable --now iscsid.service iscsid.socket
systemctl disable --now nfs-client.target remote-fs.target
systemctl disable --now ModemManager.service
systemctl disable --now atd.service

# 2. Kernel & Network Hardening (Sysctl)
cat <<EOF > /etc/sysctl.d/99-hardening.conf
kernel.randomize_va_space = 2
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.unprivileged_bpf_disabled = 1
kernel.yama.ptrace_scope = 1
kernel.perf_event_paranoid = 2
kernel.sysrq = 0

# IPv4 Hardening
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_rfc1337 = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# IPv6 Hardening (Restricted to avoid slow timeouts if IPv6 is flaky)
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
# Optimisation: Préférer IPv4 pour éviter les timeouts DNS IPv6
# (Géré via /etc/gai.conf si besoin, mais sysctl aide pour le routage)
EOF

sysctl -p /etc/sysctl.d/99-hardening.conf

# 2.1 DNS Optimization (Fix slowness)
# Force systemd-resolved caching and DNSSEC
if systemctl is-active systemd-resolved >/dev/null 2>&1; then
    mkdir -p /etc/systemd/resolved.conf.d/
    cat <<EOF > /etc/systemd/resolved.conf.d/optimization.conf
[Resolve]
DNSSEC=yes
Cache=yes
DNSOverTLS=yes
EOF
    systemctl restart systemd-resolved
fi

# 3. NetworkManager MAC Randomization
cat <<EOF > /etc/NetworkManager/conf.d/00-macrandomize.conf
[device]
wifi.scan-rand-mac-address=yes
[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
EOF
systemctl reload NetworkManager

# 4. Blacklist Unused Network Protocols
cat <<EOF > /etc/modprobe.d/blacklist-network.conf
install dccp /bin/true
install sctp /bin/true
install rds /bin/true
install tipc /bin/true
EOF

# 5. USBGuard Policy Generation
if command -v usbguard >/dev/null 2>&1; then
    if [ ! -f /etc/usbguard/rules.conf ]; then
        usbguard generate-policy > /etc/usbguard/rules.conf
        chmod 600 /etc/usbguard/rules.conf
    fi
    systemctl enable --now usbguard
fi

# 6. Auditd Policy
if command -v auditctl >/dev/null 2>&1; then
    auditctl -w /etc/sudoers -p wa -k sudoers_changes
    auditctl -w /etc/passwd -p wa -k passwd_changes
    auditctl -w /etc/shadow -p wa -k shadow_changes
    auditctl -a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k setuid_exec
fi

# 7. SELinux Enforcing
setenforce 1
sed -i 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/selinux/config

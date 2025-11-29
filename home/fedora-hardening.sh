#!/usr/bin/env bash
# === Hardening & Nettoyage Fedora (Sans exécution de binaires non-signés) ===
# À lancer avec sudo

# 1. Désactiver les services inutiles et risqués identifiés par Lynis
# Abrt (Rapports de crash) : Fuite d'info potentielle + consommation CPU
systemctl disable --now abrtd.service abrt-journal-core.service abrt-oops.service abrt-xorg.service

# Avahi (mDNS) : Inutile si pas de partage imprimante/chat local
systemctl disable --now avahi-daemon.service avahi-daemon.socket

# iSCSI / NFS : Services stockage entreprise inutiles
systemctl disable --now iscsid.service iscsid.socket
systemctl disable --now nfs-client.target remote-fs.target

# ModemManager : Inutile sans carte SIM
systemctl disable --now ModemManager.service

# atd (Planificateur legacy) : systemd timers remplacent ça
systemctl disable --now atd.service

# 2. Hardening Réseau (Optionnel mais recommandé)
# Empêcher les redirections ICMP (MitM)
echo "net.ipv4.conf.all.accept_redirects = 0" > /etc/sysctl.d/99-hardening.conf
echo "net.ipv6.conf.all.accept_redirects = 0" >> /etc/sysctl.d/99-hardening.conf
sysctl -p /etc/sysctl.d/99-hardening.conf

echo "Services désactivés et hardening sysctl appliqué."

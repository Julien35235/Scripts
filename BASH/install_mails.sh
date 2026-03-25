#!/bin/bash

LOGFILE="/var/log/mail_install.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "=== Début de l'installation du serveur mail ==="

### 1. Mise à jour du système
echo "--- Mise à jour du système ---"
apt update && apt full-upgrade -y

### 2. Installation de Postfix et Dovecot
echo "--- Installation de Postfix et Dovecot ---"
DEBIAN_FRONTEND=noninteractive apt install -y postfix postfix-pcre dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd

### 3. Configuration Postfix
echo "--- Configuration de Postfix ---"

postconf -e "myhostname=$(hostname -f)"
postconf -e "myorigin=/etc/mailname"
postconf -e "inet_interfaces=all"
postconf -e "inet_protocols=ipv4"
postconf -e "mydestination=\$myhostname, localhost"
postconf -e "home_mailbox=Maildir/"
postconf -e "smtpd_sasl_type=dovecot"
postconf -e "smtpd_sasl_path=private/auth"
postconf -e "smtpd_sasl_auth_enable=yes"
postconf -e "smtpd_recipient_restrictions=permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination"

systemctl restart postfix

### 4. Configuration Dovecot
echo "--- Configuration de Dovecot ---"

# Activer maildir
sed -i "s|#mail_location =|mail_location = maildir:~/Maildir|" /etc/dovecot/conf.d/10-mail.conf

# Activer l'authentification Unix
sed -i "s|#disable_plaintext_auth = yes|disable_plaintext_auth = no|" /etc/dovecot/conf.d/10-auth.conf
sed -i "s|auth_mechanisms = plain|auth_mechanisms = plain login|" /etc/dovecot/conf.d/10-auth.conf

# Sockets d’authentification pour Postfix
cat <<EOF >/etc/dovecot/conf.d/10-master.conf
service auth {
  unix_listener /var/spool/postfix/private/auth {
    mode = 0660
    user = postfix
    group = postfix
  }
}
EOF

systemctl restart dovecot

### 5. Création d’un utilisateur mail (exemple)
echo "--- Création d'un utilisateur mail de test ---"
useradd mailtest -m -s /bin/bash
echo "mailtest:Test1234!" | chpasswd
mkdir -p /home/mailtest/Maildir
chown -R mailtest:mailtest /home/mailtest/Maildir

### 6. Activation des services
echo "--- Activation des services ---"
systemctl enable postfix
systemctl enable dovecot

echo "=== Installation terminée ==="
echo "Logs disponibles dans : $LOGFILE"
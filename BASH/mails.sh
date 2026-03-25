#!/bin/bash

set -e

DOMAIN="example.com"
HOSTNAME="mail.$DOMAIN"
SSL_DIR="/etc/ssl/mail"

echo "==> Mise à jour du système"
apt update && apt upgrade -y

echo "==> Installation de Postfix et Dovecot"
DEBIAN_FRONTEND=noninteractive apt install -y postfix postfix-mysql dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd openssl

echo "==> Configuration du hostname"
hostnamectl set-hostname "$HOSTNAME"

echo "==> Génération des certificats SSL"
mkdir -p $SSL_DIR
openssl req -new -x509 -days 365 -nodes \
    -out $SSL_DIR/mail.pem \
    -keyout $SSL_DIR/mail.key \
    -subj "/C=FR/ST=France/L=Paris/O=IT/OU=Mail/CN=$HOSTNAME"
chmod 600 $SSL_DIR/mail.key

echo "==> Configuration de Postfix"
postconf -e "myhostname = $HOSTNAME"
postconf -e "mydomain = $DOMAIN"
postconf -e "myorigin = /etc/mailname"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain"
postconf -e "inet_interfaces = all"
postconf -e "inet_protocols = ipv4"
postconf -e "home_mailbox = Maildir/"
postconf -e "smtpd_tls_cert_file = $SSL_DIR/mail.pem"
postconf -e "smtpd_tls_key_file = $SSL_DIR/mail.key"
postconf -e "smtpd_use_tls = yes"
postconf -e "smtpd_tls_security_level = may"
postconf -e "smtp_tls_security_level = may"

echo "$DOMAIN" > /etc/mailname

echo "==> Activation des services Dovecot (IMAP & POP3)"
cat > /etc/dovecot/conf.d/10-mail.conf <<EOF
mail_location = maildir:~/Maildir
EOF

cat > /etc/dovecot/conf.d/10-auth.conf <<EOF
disable_plaintext_auth = yes
auth_mechanisms = plain login
!include auth-system.conf.ext
EOF

cat > /etc/dovecot/conf.d/10-ssl.conf <<EOF
ssl = required
ssl_cert = <$SSL_DIR/mail.pem
ssl_key = <$SSL_DIR/mail.key
EOF

echo "==> Restart des services"
systemctl restart postfix
systemctl restart dovecot

echo "==> Activation automatique"
systemctl enable postfix
systemctl enable dovecot

echo "✅ Deployment terminé !"
echo "Ajoutez un utilisateur avec : adduser utilisateur"
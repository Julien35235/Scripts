#!/bin/bash

expediteur="`hostname`-ssh@tssrlab.local"
destinataire="usertssr@tssrlab.local"
objet="`hostname` - Connexion SSH"
body="<h2><b>Serveur `hostname` - Nouvelle connexion SSH</b></h2><br><b>- Hôte distant : </b>$PAM_RHOST<br><b>- Utilisateur : </b>$PAM_USER<br><b>- Date : </b>`date`"

if [ ${PAM_TYPE} = "open_session" ]; then
    echo "${body}" | /usr/bin/mail -r "${expediteur}" -s "${objet}" "${destinataire}" -a "Content-Type: text/html"
fi
exit 0
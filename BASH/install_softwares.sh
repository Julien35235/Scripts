#!/bin/bash
#Installations des softwares en utilisant le flatpak
flatpak install flathub org.mozilla.firefox
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.anydesk.Anydesk
flatpak install flathub com.opera.Opera
flatpak install flathub com.google.Chrome
flatpak install flathub com.google.EarthPro
flatpak install flathub com.rustdesk.RustDesk
flatpak install flathub org.mozilla.Thunderbird
flatpak install flathub com.slack.Slack
flatpak install flathub chat.rocket.RocketChat
flatpak install flathub com.github.IsmaelMartinez.teams_for_linux
flatpak install flathub org.gimp.GIMP
flatpak install flathub org.kde.kdenlive
flatpak install flathub org.onlyoffice.desktopeditors
flatpak install flathub com.spotify.Client
flatpak install flathub dev.aunetx.deezer
flatpak install flathub us.zoom.Zoom
flatpak install flathub org.videolan.VLC
flatpak install flathub com.visualstudio.code

#Installation de Foxit Redear pour lire ses PDF
cd ~/Téléchargements
sudo wget http://cdn01.foxitsoftware.com/pub/foxit/reader/desktop/linux/2.x/2.4/en_us/FoxitReader.enu.setup.2.4.4.0911.x64.run.tar.gz
tar xzvf FoxitReader*.tar.gz
chmod a+x FoxitReader*.run
./FoxitReader*.run




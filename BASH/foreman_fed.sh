#Update the system packages and install the repository installer package:
sudo dnf update && dnf upgrade -y
sudo dnf install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-fedora$(rpm -E %fedora).noarch.rpm
#Install the EPEL repository, which provides additional packages for Fedora
sudo dnf install -y epel-release
#Install the Foreman packages using the dnf package manager
sudo dnf install -y foreman foreman-proxy foreman-postgresql foreman-installer
#Generate a self-signed SSL certificate for the Foreman server
sudo foreman-installer --foreman-proxy-content-certs-self-signed
#Open ports 80 and 443 for HTTP and HTTPS access
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --add-service=https --permanent
sudo firewall-cmd --reload
#Start the Foreman server and its associated services
sudo systemctl start foreman-proxy
sudo systemctl start httpd
sudo systemctl enable foreman-proxy
sudo systemctl enable httpd
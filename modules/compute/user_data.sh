apt-get update -y
apt-get install -y docker.io
systemctl enable --now docker
apt-get install -y nginx
sudo systemctl enable --now nginx

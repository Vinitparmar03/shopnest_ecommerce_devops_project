#!/bin/bash

set -e

# --------------------------------------------------
# System update
# --------------------------------------------------

apt-get update
apt-get upgrade -y


# --------------------------------------------------
# Basic utilities
# --------------------------------------------------

apt-get install -y \
  git \
  curl \
  wget \
  unzip \
  ca-certificates \
  gnupg \
  lsb-release \
  fontconfig \
  software-properties-common


# --------------------------------------------------
# Java 21
# Jenkins requires Java
# --------------------------------------------------

apt-get install -y openjdk-21-jre

echo "Java version:"
java -version


# --------------------------------------------------
# Jenkins LTS
# --------------------------------------------------

mkdir -p /etc/apt/keyrings

wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ \
  > /etc/apt/sources.list.d/jenkins.list

apt-get update

apt-get install -y jenkins

# Enable Jenkins at boot
systemctl enable jenkins
systemctl start jenkins


# --------------------------------------------------
# Docker
# --------------------------------------------------

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin


# Start Docker
systemctl enable docker
systemctl start docker


# --------------------------------------------------
# Allow Jenkins to use Docker
# --------------------------------------------------

usermod -aG docker jenkins


# --------------------------------------------------
# AWS CLI v2
# --------------------------------------------------

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o /tmp/awscliv2.zip

unzip -q /tmp/awscliv2.zip -d /tmp

/tmp/aws/install

rm -rf /tmp/aws /tmp/awscliv2.zip


# --------------------------------------------------
# kubectl
# --------------------------------------------------

curl -LO "https://dl.k8s.io/release/$(curl -L -s \
  https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

rm -f kubectl


# --------------------------------------------------
# Helm
# Kubernetes package manager
# Required for:
# - NGINX Ingress
# - Prometheus
# - Grafana
# --------------------------------------------------

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  | bash

echo "Helm version:"
helm version


# --------------------------------------------------
# Restart Jenkins
# Required after adding Jenkins to docker group
# --------------------------------------------------

systemctl restart jenkins


# --------------------------------------------------
# Display installed versions
# --------------------------------------------------

echo "======================================"
echo "Jenkins EC2 installation completed"
echo "======================================"


echo "Git:"
git --version


echo "Java:"
java -version


echo "Docker:"
docker --version


echo "Docker Compose:"
docker compose version


echo "AWS CLI:"
aws --version


echo "kubectl:"
kubectl version --client


echo "Helm:"
helm version


echo "Jenkins:"
systemctl status jenkins --no-pager || true


echo "======================================"
echo "Jenkins initial password:"
echo "======================================"


if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then

    cat /var/lib/jenkins/secrets/initialAdminPassword

else

    echo "Initial password not available yet."
    echo "Check:"
    echo "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

fi


echo "======================================"
echo "Installation Complete"
echo "======================================"
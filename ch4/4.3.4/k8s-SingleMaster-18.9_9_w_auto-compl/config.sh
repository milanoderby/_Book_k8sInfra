#!/usr/bin/env bash

# vim configuration 
echo 'alias vi=vim' >> /etc/profile

# swapoff -a to disable swapping
swapoff -a
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

# kubernetes repo
gg_pkg="packages.cloud.google.com/yum/doc" # Due to shorten addr for key
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://${gg_pkg}/yum-key.gpg https://${gg_pkg}/rpm-package-key.gpg
EOF

# docker repo
yum install yum-utils -y 
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# RHEL/CentOS 7 have reported traffic issues being routed incorrectly due to iptables bypassed
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
modprobe br_netfilter

# local small dns & vagrant cannot parse and delivery shell code.
echo "10.105.193.77 dev-ymaster-ncl.nfra.io dev-ymaster-ncl" >> /etc/hosts
echo "10.105.192.78 dev-ycontainer001-ncl.nfra.io dev-ycontainer001-ncl" >> /etc/hosts
echo "10.168.255.149 dev-ycontainer002-ncl.nfra.io dev-ycontainer002-ncl" >> /etc/hosts
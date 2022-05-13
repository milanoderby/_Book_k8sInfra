nfsdir=/nfs_shared/$1
if [ $# -eq 0 ]; then
  echo "usage: nfs-exporter.sh <name>"; exit 0
fi

if [[ ! -d $nfsdir ]]; then
  mkdir -p $nfsdir
  echo "$nfsdir 10.105.192.78(rw,sync,no_root_squash) 10.168.255.149(rw,sync,no_root_squash)" >> /etc/exports
fi

if [[ $(systemctl is-enabled nfs) -eq "disabled" ]]; then
  systemctl enable nfs
fi
  systemctl restart nfs
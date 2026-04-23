#!/usr/bin/env bash

set -e
set -x

BACKUP_FILE="$HOME/nervasion-certs-backup.yaml"

function backup_certs {
  # File to save certificates

  echo "Locating nervasion TLS secrets..."

  # Get all secrets of type kubernetes.io/tls that match 'nervasion'
  # We use 'yq' or 'sed' to remove cluster-specific metadata
  kubectl get secrets -n default --field-selector type=kubernetes.io/tls -o json | \
  jq '.items[] | select(.metadata.name | contains("nervasion")) |
      del(.metadata.uid, .metadata.resourceVersion, .metadata.creationTimestamp, .metadata.generation, .metadata.managedFields, .metadata.namespace)' \
      > nervasion-certs.json

  # Convert to a clean YAML manifest
  #kubectl create secret tls dummy --cert=dummy --key=dummy --dry-run=client -o yaml > /dev/null # Ensure k8s context
  cat nervasion-certs.json | jq -s '{"apiVersion":"v1","kind":"List","items":.}' > $BACKUP_FILE

  echo "Backup complete: $BACKUP_FILE"
  echo "️Keep this file secure! It contains your private keys."
}


function restore_certs {
  TARGET_NAMESPACE="default" # The 'Source' for your replication

  if [ ! -f "$BACKUP_FILE" ]; then
      echo " Error: $BACKUP_FILE not found."
      exit 1
  fi

  echo " Restoring certificates to namespace: $TARGET_NAMESPACE"

  # Apply the secrets to the default namespace
  kubectl apply -f $BACKUP_FILE -n $TARGET_NAMESPACE

  # Re-apply your Replicator annotations if the backup script stripped them
  kubectl annotate secret l-nervasion-com-prod-tls -n $TARGET_NAMESPACE \
    replicator.v1.mittwald.de/replication-allowed="true" \
    replicator.v1.mittwald.de/replication-allowed-namespaces=".*" --overwrite

  echo " Restore complete. Check your 'cattle-system' namespace for synchronized secrets."
}




# if [ ! -f "$BACKUP_FILE" ]; then
#   echo "File not found. Running your command now..."
#   backup_certs
# fi




./bin/vm-build -f k8s-master0-proxmox -i 300 -h pve.l.nervasion.com  -n k8s-master0
ssh root@pve.l.nervasion.com "qm resize 300 virtio0 +50G; qm start 300"



# 1. Loop until the Guest Agent responds
until ssh root@pve.l.nervasion.com "qm guest exec 300 ls" 2>/dev/null; do
    echo "   ...waiting for agent to wake up"
    sleep 10
done


echo "Waiting for K3s to generate the config file..."
until ssh root@pve.l.nervasion.com "qm guest exec 300 -- ls /etc/rancher/k3s/k3s.yaml" 2>/dev/null | grep "exitcode" | grep -q "0"; do
    echo "   ...waiting for k3s.yaml"
    sleep 10
done


ssh root@pve.l.nervasion.com "qm guest exec 300 -- cat /etc/rancher/k3s/k3s.yaml" | \
jq -r '.["out-data"]' | sed "s/127.0.0.1/10.28.10.100/g" > ~/.kube/config

# make sure this works
kubectl get nodes


./bin/vm-build -f k8s-master2-proxmox -i 302 -h pve.l.nervasion.com  -n k8s-master2
ssh root@pve.l.nervasion.com "qm resize 302 virtio0 +50G; qm start 302"



restore_certs

~/k8s/cluster-setup.sh



# ./bin/vm-build -f k8s-master1-proxmox -i 301 -h pvembp.l.nervasion.com  -n k8s-master1
# ssh root@pvembp.l.nervasion.com "qm resize 301 virtio0 +50G; qm set 301 -memory 14336 -cores 6; qm start 301"


./bin/vm-build -f k8s-worker0-proxmox -i 310 -h pve.l.nervasion.com  -n k8s-worker0
ssh root@pve.l.nervasion.com "qm resize 310 virtio0 +50G; qm set 310 -hostpci0 0000:42:00; qm start 310"




~/k8s/cluster-setup-pt2.sh

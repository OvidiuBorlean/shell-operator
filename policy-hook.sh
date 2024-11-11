#!/usr/bin/env bash

ARRAY_COUNT=`jq -r '. | length-1' $BINDING_CONTEXT_PATH`

if [[ $1 == "--config" ]] ; then
  cat <<EOF
configVersion: v1
kubernetes:
- name: OnCreateNamespace
  apiVersion: v1
  kind: Namespace
  executeHookOnEvent:
  - Added
EOF
else
  # ignore Synchronization for simplicity
  type=$(jq -r '.[0].type' $BINDING_CONTEXT_PATH)
  if [[ $type == "Synchronization" ]] ; then
    echo Got Synchronization event
    exit 0
  fi

  for IND in `seq 0 $ARRAY_COUNT`
  do
    resourceName=`jq -r ".[$IND].object.metadata.name" $BINDING_CONTEXT_PATH`

    kubectl create -n ${resourceName} -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
EOF

  done
fi

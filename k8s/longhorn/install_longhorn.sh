#!/bin/bash
# https://longhorn.io/docs/1.10.1/deploy/install/install-with-helm/
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.10.1
kubectl -n longhorn-system get pod
# Kubernetes Homelab Configuration

This repository contains the Kubernetes manifests and Helm charts for a personal homelab environment. It leverages a suite of powerful open-source tools to provide a robust and feature-rich platform for self-hosting applications.

## Core Technologies

*   **Kubernetes:** The container orchestration platform at the heart of the homelab.
*   **Traefik:** A modern HTTP reverse proxy and load balancer, used as the Ingress controller. It is configured using the `IngressRoute` CRD for flexible routing.
*   **MetalLB:** Provides a load-balancer implementation for bare-metal Kubernetes clusters, allowing services to receive external IP addresses.
*   **Kube-vip:** Offers a highly available virtual IP for the Kubernetes control plane, ensuring API server accessibility.
*   **cert-manager:** Automates the management and issuance of TLS certificates from sources like Let's Encrypt.
*   **Longhorn:** A cloud-native distributed block storage system for Kubernetes.
*   **nfs-subdir-external-provisioner:** An automatic provisioner that uses your existing NFS server to back dynamic persistent volume claims.

## Directory Structure

The repository is organized by component within the `k8s` directory:

```
k8s/
├── book_keeper/       # Helm chart for the Book Keeper Discord application
├── cert-manager/      # cert-manager configuration and installation
├── gotify/            # Helm chart for the Gotify push notification service
├── harbor/            # Helm chart for the Harbor container registry
├── kube-vip/          # Kube-vip manifests for control plane high availability
├── longhorn/          # Longhorn distributed block storage system configuration
├── metallb/           # MetalLB configuration for load balancing
├── nfs/               # NFS PersistentVolume and PersistentVolumeClaim configurations
├── traefik/           # Traefik Ingress controller configuration
├── uptimekuma/        # Helm chart for the Uptime Kuma monitoring tool
└── vaultwarden/       # Helm chart for the Vaultwarden password manager
```

## Prerequisites

*   A running Kubernetes cluster.
*   `kubectl` installed and configured to connect to your cluster.
*   [Helm](https://helm.sh/docs/intro/install/) installed for deploying charts.

## Deployment

### 1. Apply CRDs and Core Services

Before deploying applications, the core services must be running. This includes applying the necessary Custom Resource Definitions (CRDs) for Traefik and cert-manager, and then deploying the services themselves.

It is recommended to apply the configurations in the following order:
1.  `k8s/metallb/`
2.  `k8s/kube-vip/`
3.  `k8s/longhorn/`
4.  `k8s/traefik/`
5.  `k8s/cert-manager/`

### 2. Deploying Helm Charts

Applications like Vaultwarden are packaged as Helm charts. To deploy them, navigate to the chart's directory and use the `helm upgrade --install` command.

**Example: Deploying Vaultwarden**

To perform a dry run and review the generated manifests:
```bash
helm template vaultwarden k8s/vaultwarden -f k8s/vaultwarden/values.yaml -f k8s/vaultwarden/vaultwarden-secrets.yaml --namespace vaultwarden
```

To deploy the chart to your cluster:
```bash
helm upgrade --install vaultwarden k8s/vaultwarden -f k8s/vaultwarden/values.yaml -f k8s/vaultwarden/vaultwarden-secrets.yaml --namespace vaultwarden --create-namespace
```

## Configuration

Each component can be configured by modifying its respective YAML files. For Helm charts, the `values.yaml` file provides an easy way to customize the deployment.

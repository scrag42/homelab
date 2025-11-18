# Kubernetes Homelab Configuration

This repository contains the Kubernetes manifests and Helm charts for a personal homelab environment. It leverages a suite of powerful open-source tools to provide a robust and feature-rich platform for self-hosting applications.

## Core Technologies

*   **Kubernetes:** The container orchestration platform at the heart of the homelab.
*   **Traefik:** A modern HTTP reverse proxy and load balancer, used as the Ingress controller. It is configured using the `IngressRoute` CRD for flexible routing.
*   **MetalLB:** Provides a load-balancer implementation for bare-metal Kubernetes clusters, allowing services to receive external IP addresses.
*   **Kube-vip:** Offers a highly available virtual IP for the Kubernetes control plane, ensuring API server accessibility.
*   **cert-manager:** Automates the management and issuance of TLS certificates from sources like Let's Encrypt.

## Directory Structure

The repository is organized by component within the `k8s` directory:

```
k8s/
├── cert-manager/      # cert-manager configuration and installation
├── kube-vip/          # Kube-vip manifests for control plane high availability
├── metallb/           # MetalLB configuration for load balancing
├── traefik/           # Traefik Ingress controller configuration
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
3.  `k8s/traefik/`
4.  `k8s/cert-manager/`

### 2. Deploying Helm Charts

Applications like Vaultwarden are packaged as Helm charts. To deploy them, navigate to the chart's directory and use the `helm install` command.

**Example: Deploying Vaultwarden**

To perform a dry run and review the generated manifests:
```bash
helm template <release-name> k8s/vaultwarden --values k8s/vaultwarden/values.yaml --set env.ADMIN_TOKEN='your-secure-token'
```

To deploy the chart to your cluster:
```bash
helm install <release-name> k8s/vaultwarden --values k8s/vaultwarden/values.yaml --set env.ADMIN_TOKEN='your-secure-token'
```

Replace `<release-name>` with a name for your deployment (e.g., `my-vaultwarden`).

## Configuration

Each component can be configured by modifying its respective YAML files. For Helm charts, the `values.yaml` file provides an easy way to customize the deployment.

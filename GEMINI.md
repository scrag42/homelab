# Gemini Code Understanding

## Project Overview

This repository contains the Kubernetes manifests and Helm charts for a personal homelab environment. It leverages a suite of powerful open-source tools to provide a robust and feature-rich platform for self-hosting applications. The core technologies used are Kubernetes, Traefik, MetalLB, Kube-vip, cert-manager, and Longhorn.

The project is structured around a central `k8s` directory, which contains subdirectories for each component. Each subdirectory contains the necessary Kubernetes manifests and Helm charts for that component.

## Building and Running

### Prerequisites

*   A running Kubernetes cluster.
*   `kubectl` installed and configured to connect to your cluster.
*   [Helm](https://helm.sh/docs/intro/install/) installed for deploying charts.

### Deployment

The `README.md` file recommends deploying the core services in the following order:

1.  `k8s/metallb/`
2.  `k8s/kube-vip/`
3.  `k8s/traefik/`
4.  `k8s/cert-manager/`

Applications are deployed using Helm charts. The general command for deploying a Helm chart is consistent across the project; therefore, specific deployment examples will only be provided in `README.md` for unique cases that deviate from the standard pattern. For example, to deploy Vaultwarden:

```bash
helm upgrade --install vaultwarden k8s/vaultwarden -f k8s/vaultwarden/values.yaml -f k8s/vaultwarden/vaultwarden-secrets.yaml --namespace vaultwarden --create-namespace
```

## Development Conventions

The project follows a declarative approach to infrastructure management, with all configurations defined in YAML files. The use of Helm charts for applications allows for easy customization and deployment.

The project uses `cert-manager` with a Cloudflare `ClusterIssuer` to automatically provision and manage TLS certificates for its services. This indicates a convention of using DNS-01 challenges for certificate issuance, which is a robust and secure method.

The use of `IngressRoute` custom resources for Traefik suggests a preference for the Kubernetes Gateway API over the traditional Ingress API, which allows for more flexible and powerful routing configurations.

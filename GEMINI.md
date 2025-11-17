# GEMINI Project: Kubernetes Homelab Configuration

## Project Overview

This project contains the Kubernetes configuration files (manifests) for a homelab environment. It uses a combination of popular open-source tools to provide robust networking and ingress capabilities for a Kubernetes cluster.

The core technologies used are:

*   **Kubernetes:** The container orchestration platform.
*   **Traefik:** A modern HTTP reverse proxy and load balancer that makes deploying microservices easy. It is used here as an Ingress controller.
*   **MetalLB:** A load-balancer implementation for bare metal Kubernetes clusters, using standard routing protocols.
*   **Kube-vip:** Provides a virtual IP and load balancer for the Kubernetes control plane.

## Architecture

The project is structured to configure the following components in a Kubernetes cluster:

*   **Ingress:** Traefik is configured as the Ingress controller, managing external access to services within the cluster. The configuration in `k8s/traefik/traefik-values.yaml` enables the Traefik dashboard and sets up the Kubernetes Gateway API provider. It also enforces HTTPS by redirecting HTTP traffic.

*   **Load Balancing:** MetalLB is configured in Layer 2 mode to provide load balancing services. It assigns external IP addresses to services of type `LoadBalancer` from the IP address pool `192.168.42.60-192.168.42.69`, as defined in `k8s/metallb/metallb-config.yaml`.

*   **High Availability:** Kube-vip is used to provide a highly available virtual IP (`192.168.42.99`) for the Kubernetes control plane. This ensures that the Kubernetes API server is always accessible, even if one of the control plane nodes fails. The configuration for this is in `k8s/kube-vip/daemonset.yaml`.

## Building and Running

These configuration files are intended to be applied to a running Kubernetes cluster.

### Prerequisites

*   A running Kubernetes cluster.
*   `kubectl` installed and configured to connect to your cluster.
*   Helm is installed on the machine being used to deploy the charts.

## Development Conventions

*   **Directory Structure:** The configuration files are organized by component into subdirectories within the `k8s` directory.
*   **File Naming:** Files are named descriptively to indicate their purpose (e.g., `daemonset.yaml`, `rbac.yaml`).
*   **YAML:** All configuration is written in YAML.

# Immich on Kubernetes

This directory contains the manifests to deploy Immich on a Kubernetes cluster using Helm, with a PostgreSQL database managed by the CloudNativePG operator and storage provided by NFS and Longhorn.

## Prerequisites

1.  **CloudNativePG Operator:** A running instance of the [CloudNativePG operator](https://cloudnative-pg.io/) is required.
2.  **NFS Subdir External Provisioner:** This is used for dynamic provisioning of the Immich library volume.
3.  **Longhorn:** Used for the database's persistent volume.
4.  **Traefik & cert-manager:** Used for ingress and automatic TLS certificate management.
5.  **Cloudflare ClusterIssuer:** A `ClusterIssuer` named `cloudflare-clusterissuer` must be configured for `cert-manager` to issue certificates via Cloudflare's DNS-01 challenge.

## Configuration Steps

This deployment required several specific configurations to work within this homelab environment.

### 1. Namespace and PVCs

A dedicated `immich` namespace was created. Two Persistent Volume Claims (PVCs) were also set up:
*   `immich-library-pvc`: A `ReadWriteMany` PVC using the `nfs-slow` StorageClass for the main photo library.
*   `immich-database-pvc`: A `ReadWriteOnce` PVC using the `longhorn` StorageClass for the database. *(Note: This PVC is managed by the CloudNativePG operator, but was created as part of the initial setup.)*

### 2. PostgreSQL Database (CloudNativePG)

The PostgreSQL database is defined in `cloudnative-pg.yaml`. Key configurations:
*   The database (`Cluster`) is deployed into the `immich` namespace.
*   The `imageName` is set to `ghcr.io/tensorchord/cloudnative-vectorchord:16.9-0.4.3` to provide the necessary `vchord` (vectors) extension.
*   The `bootstrap` section is configured to automatically create the `immich` database and set the owner to `app`.
*   The `shared_preload_libraries` includes `"vchord.so"`.

After the database cluster was healthy, the following commands were run to manually create the necessary extensions as a superuser, which Immich requires for its initial startup:
```bash
kubectl exec -n immich immich-database-1 -- psql -U postgres -d immich -c "CREATE EXTENSION vchord CASCADE; CREATE EXTENSION earthdistance CASCADE;"
kubectl exec -n immich immich-database-1 -- psql -U postgres -d immich -c "ALTER USER app WITH SUPERUSER;"
```
**Important:** After the first successful startup of the Immich server pod, the superuser privileges were revoked for security:
```bash
kubectl exec -n immich immich-database-1 -- psql -U postgres -d immich -c "ALTER USER app WITH NOSUPERUSER;"
```

### 3. Helm `values.yaml` Configuration

The `k8s/immich/values.yaml` file was customized as follows:
*   `controllers.main.containers.main.image.tag`: Set to `v2.3.1`.
*   **Database Connection:** The `env` section was configured to connect to the CloudNativePG database service (`immich-database-rw.immich.svc.cluster.local`) and to use a Kubernetes secret for the password:
    ```yaml
    DB_PASSWORD:
      valueFrom:
        secretKeyRef:
          name: immich-database-app
          key: password
    ```
*   `immich.persistence.library.existingClaim`: Set to `immich-library-pvc`.
*   `valkey.enabled`: Set to `true` to enable the in-chart Redis dependency.
*   `server.ingress.main.enabled`: Set to `false` to disable the default Ingress and avoid conflicts with the manual `IngressRoute`.

### 4. Traefik Ingress and TLS

*   An `IngressRoute` was created in `immich-ingressroute.yaml` to expose the `immich-server` service at `immich.wheelerlab.dev`.
*   A `Certificate` was created in `immich-cert.yaml` to request a TLS certificate from `cert-manager`. The `secretName` was set to `immich-cert`.
*   The `IngressRoute` was then configured to use this secret for TLS termination:
    ```yaml
    tls:
      secretName: immich-cert
    ```

## Deployment

With all manifests and configurations in place, the application was deployed using Helm:
```bash
helm upgrade --install immich oci://ghcr.io/immich-app/immich-charts/immich -f k8s/immich/values.yaml --namespace immich
```

# Kubernetes Deployment (Helm)

Deploy OpsDeck on Kubernetes using the included Helm chart, with support for internal or external PostgreSQL, persistent storage, and Ingress.

## Prerequisites

- Kubernetes cluster v1.19+
- Helm 3.0+
- `kubectl` configured for your cluster

## Chart structure

```
helm/
├── Chart.yaml          # Chart metadata and PostgreSQL subchart dependency
├── Chart.lock
├── values.yaml         # Default configuration
├── charts/             # Bundled PostgreSQL subchart
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    └── pvc.yaml
```

## Installation

### 1. Create namespace and secrets

```bash
kubectl create namespace opsdeck

kubectl create secret generic opsdeck-secrets \
  --from-literal=secret-key='$(openssl rand -hex 32)' \
  --from-literal=admin-email='admin@yourcompany.com' \
  --from-literal=admin-password='SecurePassword123!' \
  -n opsdeck
```

### 2. Configure values

The key decision is database mode — **internal** (deploys a PostgreSQL pod) or **external** (uses an existing database like RDS/Aurora):

=== "Internal PostgreSQL"

    ```yaml
    # values.yaml
    database:
      type: internal

    postgresql:
      auth:
        username: opsdeck
        password: opsdeck-db-password
        database: opsdeck
    ```

=== "External PostgreSQL (RDS/Aurora)"

    ```yaml
    # values.yaml
    database:
      type: external
      external:
        host: "my-aurora-db.aws.com"
        port: 5432
        username: "opsdeck"
        database: "opsdeck"
        existingSecret:
          name: "opsdeck-db-secret"
          key: "password"
    ```

### 3. Configure persistent storage

```yaml
persistence:
  logs:
    enabled: true
    size: 500Mi
    storageClass: ""       # Uses cluster default
    existingClaim: ""      # Or reference an existing PVC
  
  attachments:
    enabled: true
    size: 5Gi
    storageClass: ""
    existingClaim: ""
```

### 4. Install

```bash
helm upgrade --install opsdeck ./helm \
  --namespace opsdeck \
  --set image.tag=latest
```

### 5. Verify

```bash
kubectl get pods -n opsdeck
kubectl logs -f deployment/opsdeck -n opsdeck
```

## Ingress

Enable and configure Ingress in `values.yaml`:

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: opsdeck.yourcompany.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: opsdeck-tls
      hosts:
        - opsdeck.yourcompany.com
```

## ArgoCD deployment

For GitOps workflows, create an ArgoCD Application manifest:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: opsdeck
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/pixelotes/opsdeck.git'
    targetRevision: HEAD
    path: helm/
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: opsdeck
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

```bash
kubectl apply -f application.yaml
```

## Scaling

OpsDeck can run multiple replicas behind the Kubernetes Service load balancer. Ensure:

- External PostgreSQL (internal PostgreSQL is not designed for multi-replica).
- Shared storage for attachments (ReadWriteMany PVC or S3-compatible storage).
- `SECRET_KEY` is identical across all replicas (from the shared Secret).

## values.yaml reference

| Key | Default | Description |
|---|---|---|
| `image.repository` | `pixelotes/opsdeck` | Container image |
| `image.tag` | `latest` | Image tag |
| `image.pullPolicy` | `IfNotPresent` | Pull policy |
| `service.type` | `ClusterIP` | Service type |
| `service.port` | `5000` | Service port |
| `database.type` | `internal` | `internal` or `external` |
| `persistence.logs.enabled` | `true` | Enable log persistence |
| `persistence.logs.size` | `500Mi` | Log volume size |
| `persistence.attachments.enabled` | `true` | Enable attachment persistence |
| `persistence.attachments.size` | `5Gi` | Attachment volume size |

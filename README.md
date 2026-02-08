# Demo Devops NodeJs

This is a simple application to be used in the technical test of DevOps.

## Getting Started

### Prerequisites

- **Node.js:** 18.x (LTS)
- **Docker:** Desktop (with Kubernetes enabled) or Minikube
- **kubectl:** v1.25+

### Installation

Clone this repo.

```bash
git clone https://github.com/pupialesjose/devsu-demo.git
```

Install dependencies.

```bash
npm install
```

### Database

The database is generated as a file in the main path when the project is first run, and its name is `dev.sqlite`.

Consider giving access permissions to the file for proper functioning.

## Dockerization

The application uses a Multi-stage Build to minimize image size and increase security.

- **Base Image:** node:18-alpine (for a lightweight footprint).

- **Build Stage:** Runs npm install and prepares the environment.

- **Production Stage:** Contains only production dependencies and the source code.

## Build and Run locally:

### 1. Build the image:

```bash
docker build -t devsu-app:latest .
```

## Build and Run locally:

### 2. Run the container:

```bash
docker run -d -p 8000:8000 --name devsu-container devsu-app:latest
```

### 3. Open http://localhost:8000/api/users with your browser.

## Kubernetes Orchestration
The solution includes production-ready manifests in the k8s/ directory.

Key Features:
- **Scalability:** Configured with replicas: 2 for high availability.

- **Auto-scaling:** Horizontal Pod Autoscaler (HPA) set to scale from 2 to 5 replicas based on CPU (70% threshold).

- **Security:** Sensitive data like DB_PASSWORD is managed via Kubernetes Secrets.

- **Config Management:** Environment variables (NODE_ENV, PORT) managed via ConfigMaps.

- **Networking:** Service (ClusterIP) and Ingress rules for traffic management.

## Deployment steps:
### 1. Apply all manifests:

```bash
kubectl apply -f k8s/
```

### 2. Access the app via Kubernetes (Port-forwarding):

```bash
kubectl port-forward service/devsu-app-service 8080:80
```

### 3. Open http://localhost:8080/api/users with your browser.


## CI/CD Pipeline
A fully automated pipeline is configured via GitHub Actions (.github/workflows/main.yml).

- **Validation:** Runs npm run test -- --forceExit on every push to ensure 100% test compliance.

- **Coverage:** Generates a code coverage report during the test phase.

- **Security:** Includes an Anchore Scan step to audit the Docker image for vulnerabilities before deployment.

- **Build:** Automatically validates the Docker build process on Ubuntu-latest runners.


### Features

These services can perform,

#### Create User

To create a user, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: POST
```

```json
{
    "dni": "dni",
    "name": "name"
}
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "error": "error"
}
```

#### Get Users

To get all users, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
[
    {
        "id": 1,
        "dni": "dni",
        "name": "name"
    }
]
```

#### Get User

To get an user, the endpoint **/api/users/<id>** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the user id does not exist, we will receive status 404 and the following message:

```json
{
    "error": "User not found: <id>"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "errors": [
        "error"
    ]
}
```

## License

Copyright © 2023 Devsu. All rights reserved.

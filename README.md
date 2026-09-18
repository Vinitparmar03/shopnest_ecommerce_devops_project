# 🛒 ShopNest E-commerce DevOps Project

## 📌 About the Project

**ShopNest** is a simple e-commerce project that is being used as the foundation for a DevOps learning and implementation project.

The original application was created by **Shivansh Vasu**, and this repository is based on that project.

## 🙏 Appreciation & Credits

I would like to sincerely thank **Shivansh Vasu** for creating and sharing the original ShopNest e-commerce project.

The original project provided a useful foundation for me to learn and implement DevOps concepts around a real-world application.

**Original GitHub Repository:** https://github.com/ShivaMani02/shopnest-ecom-MERN

**YouTube:** https://www.youtube.com/@shivanshvasu

> **Credits:** All credit for the original e-commerce application and its source code belongs to the original creator. This repository uses the project as a foundation for educational and DevOps learning purposes.


## 🐳 Running the Project with Docker Compose

You can run the complete application locally using **Docker Compose**.

### 1. Create Environment Files

First, create a `.env` file in both the **frontend** and **backend** directories.

The required environment variables are already listed in the respective `env.example` files.

Use these files as a reference to know which values you need to provide.

**Frontend:**
```bash
cd frontend
cp env.example .env
```

**Backend:**
```bash
cd backend
cp env.example .env
```

Then update the `.env` files with your required configuration values.


### 2. Start the Application

After configuring the environment variables, navigate to the Docker Compose directory:

```bash
cd docker-compose
```

Run the following command:

```bash
docker compose -f docker-compose.yml up --build
```

The `--build` option ensures that Docker rebuilds the frontend and backend images before starting the services.

### 3. Access the Application

Once all services are successfully started, open your browser and visit:

```text
http://localhost:80
```

Or simply:

```text
http://localhost
```

The application should now be available locally.

### 4. Stop the Services

To stop the running containers, press:

```text
Ctrl + C
```

Or, if the containers are running in detached mode:

```bash
docker compose -f docker-compose.yml down
```




## ☸️ Running the Project on Kubernetes with Minikube

ShopNest can also be deployed locally using **Kubernetes and Minikube**.

The Kubernetes setup includes:

- Frontend Deployment & Service
- Backend Deployment & Service
- Kubernetes Ingress
- Kubernetes Secrets & ConfigMaps
- Horizontal Pod Autoscaler (HPA)
- NGINX Ingress Controller
- Prometheus
- Grafana
- ServiceMonitor

---

## 1. Start Minikube

First, make sure Minikube is installed and start the cluster:

```bash
minikube start
```

Check the Minikube cluster:

```bash
minikube status
```

---

## 2. Configure Local Hostnames

After starting Minikube, find its IP address:

```bash
minikube ip
```

For example, if Minikube returns:

```text
192.168.49.2
```

you need to map this IP address to the ShopNest, Prometheus, and Grafana hostnames in your `/etc/hosts` file.

Open the file:

```bash
sudo nano /etc/hosts
```

Add:

```text
192.168.49.2    shopnest.com
192.168.49.2    prometheus.shopnest.com
192.168.49.2    grafana.shopnest.com
```

Save the file.

> **Note:** The Minikube IP can be different on your machine. Always use the IP returned by `minikube ip`.

---

## 3. Update the Frontend Ingress Configuration

Before deploying the application, update the local Ingress configuration.

After cloning the repository, open:

```text
k8s/ingress/ingress.yml
```

If the Ingress currently looks like:

```yaml
rules:
  - http:
      paths:
        - path: /
```

change it to:

```yaml
rules:
  - host: shopnest.com
    http:
      paths:
        - path: /
          pathType: Prefix
```

### Why?

The `host` field tells Kubernetes that requests for:

```text
shopnest.com
```

should be handled by this Ingress rule.

For a single host, use:

```yaml
host: shopnest.com
```

**not:**

```yaml
hosts: shopnest.com
```

---

## 4. Configure Kubernetes Secrets

The repository contains a `k8s/secret/` directory containing the required Kubernetes Secret and configuration files.

These include:

- Authentication Secret
- Backend Configuration
- Cloudinary Secret
- Gmail Secret
- MongoDB Secret
- Razorpay Secret

Before applying the Kubernetes manifests, update the values in these files with your own credentials and configuration.

For example:

```yaml
stringData:
  JWT_SECRET: "YOUR_SECRET"
```

Replace the placeholder values with your actual values.


---

## 5. Install NGINX Ingress Controller

Enable the NGINX Ingress Controller in Minikube:

```bash
minikube addons enable ingress
```

Check that the controller is running:

```bash
kubectl get pods -n ingress-nginx
```

---

## 6. Install Prometheus and Grafana Using Helm

Add the Prometheus Community Helm repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Update the Helm repositories:

```bash
helm repo update
```

Create the monitoring namespace:

```bash
kubectl create namespace monitoring
```

Install the `kube-prometheus-stack`:

```bash
helm install monitoring \
  prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f ./k8s/monitoring/values_local.yml
```

This installs the monitoring stack, including **Prometheus and Grafana**, into the `monitoring` namespace.

Check the monitoring pods:

```bash
kubectl get pods -n monitoring
```

---

## 7. Deploy the Application

Once the required configuration has been updated, apply the Kubernetes manifests.

From the project root, run:

```bash
kubectl apply -f ./k8s/backend
kubectl apply -f ./k8s/frontend
kubectl apply -f ./k8s/ingress/ingress.yml
kubectl apply -f ./k8s/monitoring/service_monitor.yml
```

Apply your Secrets/ConfigMaps as well if they are stored separately:

```bash
kubectl apply -f ./k8s/secret
```

---

## 8. Verify the Deployment

Check all pods:

```bash
kubectl get pods
```

Check services:

```bash
kubectl get services
```

Check the Ingress:

```bash
kubectl get ingress
```

Check HPA:

```bash
kubectl get hpa
```

Check Prometheus and Grafana:

```bash
kubectl get pods -n monitoring
```

---

## 9. Access the Applications

Once everything is running, you can access the applications using the hostnames configured in `/etc/hosts`.

### 🛒 ShopNest

```text
http://shopnest.com
```

### 📊 Prometheus

```text
http://prometheus.shopnest.com
```

### 📈 Grafana

```text
http://grafana.shopnest.com
```

For the local Grafana configuration above:

```text
Username: admin
Password: admin
```

> ⚠️ Change the default Grafana password when using this setup beyond local development.

---

## 🔍 Useful Kubernetes Commands

View all resources:

```bash
kubectl get all
```

View resources in the monitoring namespace:

```bash
kubectl get all -n monitoring
```

View pod logs:

```bash
kubectl logs <pod-name>
```

Describe a pod:

```bash
kubectl describe pod <pod-name>
```

Check HPA:

```bash
kubectl get hpa
```

Check Ingress:

```bash
kubectl describe ingress
```

---

## 🧹 Remove the Kubernetes Deployment

To remove the application resources:

```bash
kubectl delete -f ./backend
kubectl delete -f ./frontend
kubectl delete -f ./ingress/ingress.yml
kubectl delete -f ./monitoring/service_monitor.yml
```

To remove the monitoring stack:

```bash
helm uninstall monitoring -n monitoring
```

To stop Minikube:

```bash
minikube stop
```
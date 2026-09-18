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

> ⚠️ Do not commit your `.env` files to GitHub. They may contain sensitive information such as API keys, database credentials, and secrets.

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
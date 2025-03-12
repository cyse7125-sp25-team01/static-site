# 📌 Static Site with Caddy and Jenkins Pipeline
........
This project sets up a **static website** served using the **Caddy** web server, containerized with **Docker**, and deployed via a **Jenkins pipeline**. The pipeline builds a **multi-architecture** image and pushes it to **Docker Hub**.

---

## 📁 Project Structure

```sh
.
├── index.html
├── Caddyfile
├── Dockerfile
├── README.md
└── Jenkinsfile
```

---

## 🚀 Prerequisites

Before running this project, ensure you have:

- **Docker** (with Buildx support)
- **Jenkins** (with Docker and Git integration)
- **GitHub repository access**
- **Docker Hub account** (for pushing images)
- **Configured credentials in Jenkins**
  - **GitHub PAT** (`CloudJenkinsGitHubPAT`)
  - **Docker Hub Credentials** (`CloudJenkinsDockerHubPAT`)

---

## 🛠️ Setup Instructions

### 1️⃣ Clone the Repository

```sh
git clone https://github.com/saimanas17/static-site.git
cd static-site
```

---

### 2️⃣ Run Locally with Docker

#### 🏗️ Build the Docker Image

```sh
docker build -t saimanasg/static-site:latest .
```

#### ▶️ Run the Container

```sh
docker run -p 8080:8080 saimanasg/static-site:latest
```

Now, open your browser and visit:  
➡️ **http://localhost:8080**

---

---

## 🔄 CI/CD Pipeline with Jenkins

1. **Set up credentials in Jenkins**  
   Go to **Jenkins Dashboard** → **Manage Jenkins** → **Manage Credentials** and add:

   - **GitHub PAT** → `CloudJenkinsGitHubPAT`
   - **Docker Hub Credentials** → `CloudJenkinsDockerHubPAT`

2. **Create a New Pipeline Job**

   - Open **Jenkins Dashboard** → **New Item**.
   - Select **Pipeline** and name it **Static-Site-Pipeline**.
   - Under **Pipeline Definition**, select **Pipeline script from SCM**.
   - Set **SCM** to **Git** and enter your repository URL:
     ```
     https://github.com/saimanas17/static-site.git
     ```
   - Set **Credentials** to `CloudJenkinsGitHubPAT`.
   - Specify the branch as `main`.

3. **Set Up Webhook**  
   After creating the pipeline job, set up a **GitHub webhook** to trigger the Jenkins job whenever there is a push to the repository.  
   In your GitHub repository:

   - Go to **Settings** → **Webhooks** → **Add webhook**.
   - Set the **Payload URL** to your Jenkins webhook URL (usually `http://<your-jenkins-server>/github-webhook/`).
   - Select **Just the push event**.
   - Save the webhook.

4. **Run the Pipeline**  
   Once the webhook is set up, pushing to the repository will automatically trigger the Jenkins pipeline.  
   If successful, the Docker image will be pushed to **Docker Hub**.  
   Verify the image on Docker Hub:
   ```
   docker pull saimanasg/static-site:latest
   ```
   Deploy the container:
   ```sh
   docker run -p 8080:8080 saimanasg/static-site:latest
   ```
   Open **http://localhost:8080** to view the site.

✅ **Your static site is now deployed using Jenkins CI/CD!** 🚀

---

## 📢 Notes

- The Docker image supports **multi-architecture builds** (`linux/amd64`, `linux/arm64`, `windows/amd64`, `linux/ppc64le`).
- Caddy serves static files from `/usr/share/caddy`.
- HTTPS is disabled for local testing.

---

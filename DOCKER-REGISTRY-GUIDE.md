# Docker Registry Setup Guide for Salesforce MCP Server

This guide will help you set up and manage your Salesforce MCP Server Docker image across different registries.

## 🐳 Your Docker Image

**Image Name:** `salesforce-mcp-server:latest`  
**Size:** ~224MB  
**Base:** Node.js 18 Alpine  
**Port:** 3000  

## 🚀 Quick Start

### 1. Build the Image
```bash
./docker-registry-setup.sh build
```

### 2. Run Locally
```bash
./docker-registry-setup.sh run
```

### 3. Test the Container
- **Health Check:** http://localhost:3000/
- **MCP Endpoint:** http://localhost:3000/mcp

## 📦 Registry Options

### Option 1: Docker Hub (docker.io)
**Best for:** Public sharing, easy access  
**Cost:** Free for public repos, $5/month for private repos  

```bash
# Login to Docker Hub
docker login

# Tag for Docker Hub
./docker-registry-setup.sh tag docker.io/yourusername v1.0.0

# Push to Docker Hub
./docker-registry-setup.sh push docker.io/yourusername v1.0.0

# Pull from Docker Hub
./docker-registry-setup.sh pull docker.io/yourusername v1.0.0
```

**Your Image URL:** `docker.io/yourusername/salesforce-mcp-server:v1.0.0`

### Option 2: GitHub Container Registry (ghcr.io)
**Best for:** Open source projects, GitHub integration  
**Cost:** Free for public repos, included with GitHub Pro  

```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u yourusername --password-stdin

# Tag for GitHub Container Registry
./docker-registry-setup.sh tag ghcr.io/yourusername v1.0.0

# Push to GitHub Container Registry
./docker-registry-setup.sh push ghcr.io/yourusername v1.0.0

# Pull from GitHub Container Registry
./docker-registry-setup.sh pull ghcr.io/yourusername v1.0.0
```

**Your Image URL:** `ghcr.io/yourusername/salesforce-mcp-server:v1.0.0`

### Option 3: Amazon ECR
**Best for:** AWS integration, enterprise use  
**Cost:** Pay per GB stored and transferred  

```bash
# Login to ECR
aws ecr get-login-password --region your-region | docker login --username AWS --password-stdin your-account-id.dkr.ecr.your-region.amazonaws.com

# Tag for ECR
./docker-registry-setup.sh tag your-account-id.dkr.ecr.your-region.amazonaws.com v1.0.0

# Push to ECR
./docker-registry-setup.sh push your-account-id.dkr.ecr.your-region.amazonaws.com v1.0.0
```

**Your Image URL:** `your-account-id.dkr.ecr.your-region.amazonaws.com/salesforce-mcp-server:v1.0.0`

### Option 4: Google Container Registry (gcr.io)
**Best for:** Google Cloud integration  
**Cost:** Pay per GB stored and transferred  

```bash
# Login to GCR
gcloud auth configure-docker

# Tag for GCR
./docker-registry-setup.sh tag gcr.io/your-project-id v1.0.0

# Push to GCR
./docker-registry-setup.sh push gcr.io/your-project-id v1.0.0
```

**Your Image URL:** `gcr.io/your-project-id/salesforce-mcp-server:v1.0.0`

## 🔧 Manual Commands

If you prefer to run commands manually instead of using the script:

### Build
```bash
docker build -t salesforce-mcp-server:latest .
```

### Tag
```bash
docker tag salesforce-mcp-server:latest registry-url/salesforce-mcp-server:tag
```

### Push
```bash
docker push registry-url/salesforce-mcp-server:tag
```

### Pull
```bash
docker pull registry-url/salesforce-mcp-server:tag
```

### Run
```bash
docker run -p 3000:3000 \
  -e NODE_ENV=production \
  -e PORT=3000 \
  -e HOST=0.0.0.0 \
  salesforce-mcp-server:latest
```

## 🌐 Using with Docker Compose

### Local Development
```bash
docker-compose up
```

### Production Deployment
```bash
# Update docker-compose.yml with your registry image
version: '3.8'
services:
  salesforce-mcp-server:
    image: your-registry/salesforce-mcp-server:v1.0.0
    ports:
      - "3000:3000"
    environment:
      - SALESFORCE_USERNAME=your_username
      - SALESFORCE_PASSWORD=your_password
      - SALESFORCE_TOKEN=your_token
```

## 🔐 Environment Variables

Set these environment variables when running the container:

```bash
# Required for Salesforce connection
SALESFORCE_USERNAME=your_username
SALESFORCE_PASSWORD=your_password
SALESFORCE_TOKEN=your_security_token

# Optional
SALESFORCE_CONNECTION_TYPE=User_Password  # or OAuth_2.0_Client_Credentials
SALESFORCE_INSTANCE_URL=https://login.salesforce.com
NODE_ENV=production
PORT=3000
HOST=0.0.0.0
```

## 📋 Registry Comparison

| Registry | Pros | Cons | Best For |
|----------|------|------|----------|
| **Docker Hub** | Free, widely supported, easy setup | Rate limits, public by default | Public sharing, learning |
| **GitHub CR** | Free, GitHub integration, private repos | GitHub account required | Open source, GitHub projects |
| **Amazon ECR** | AWS integration, enterprise features | Cost, AWS account required | AWS environments |
| **Google CR** | GCP integration, enterprise features | Cost, GCP account required | Google Cloud environments |

## 🚨 Security Best Practices

1. **Use Private Repositories** for production images
2. **Scan Images** for vulnerabilities before deployment
3. **Use Specific Tags** instead of `latest` in production
4. **Rotate Credentials** regularly
5. **Monitor Access** to your registries

## 🔍 Troubleshooting

### Common Issues

**Authentication Failed:**
```bash
# Re-login to your registry
docker logout registry-url
docker login registry-url
```

**Push Denied:**
- Check if you have write permissions
- Verify the repository exists
- Ensure you're logged in with the correct account

**Pull Failed:**
- Check if the image exists in the registry
- Verify the image name and tag
- Ensure you have read permissions

### Getting Help

- **Docker Hub:** https://hub.docker.com/support/
- **GitHub CR:** https://docs.github.com/en/packages/working-with-a-github-packages-registry
- **Amazon ECR:** https://docs.aws.amazon.com/ecr/
- **Google CR:** https://cloud.google.com/container-registry/docs

## 📚 Next Steps

1. **Choose a Registry** based on your needs
2. **Set up Authentication** for your chosen registry
3. **Push Your Image** using the provided script
4. **Share Your Image** with your team or community
5. **Set up CI/CD** to automatically build and push new versions

---

**Happy Containerizing! 🐳✨**

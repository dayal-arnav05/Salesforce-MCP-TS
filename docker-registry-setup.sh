#!/bin/bash

# Docker Registry Setup Script for Salesforce MCP Server
# This script helps you manage your Docker image across different registries

set -e

IMAGE_NAME="salesforce-mcp-server"
VERSION="latest"
REGISTRY_URL=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Salesforce MCP Server Docker Registry Management ===${NC}\n"

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  build                    Build the Docker image"
    echo "  tag [registry] [tag]     Tag image for specific registry"
    echo "  push [registry] [tag]    Push image to registry"
    echo "  pull [registry] [tag]    Pull image from registry"
    echo "  run                      Run the container locally"
    echo "  clean                    Clean up local images"
    echo ""
    echo "Examples:"
    echo "  $0 build"
    echo "  $0 tag docker.io/yourusername v1.0.0"
    echo "  $0 push docker.io/yourusername v1.0.0"
    echo "  $0 tag ghcr.io/yourusername v1.0.0"
    echo "  $0 push ghcr.io/yourusername v1.0.0"
    echo ""
}

# Function to build image
build_image() {
    echo -e "${YELLOW}Building Docker image...${NC}"
    docker build -t ${IMAGE_NAME}:${VERSION} .
    echo -e "${GREEN}✓ Image built successfully: ${IMAGE_NAME}:${VERSION}${NC}"
}

# Function to tag image
tag_image() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "${RED}Error: Registry and tag are required${NC}"
        echo "Usage: $0 tag [registry] [tag]"
        exit 1
    fi
    
    REGISTRY=$1
    TAG=$2
    FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}:${TAG}"
    
    echo -e "${YELLOW}Tagging image as ${FULL_IMAGE_NAME}...${NC}"
    docker tag ${IMAGE_NAME}:${VERSION} ${FULL_IMAGE_NAME}
    echo -e "${GREEN}✓ Image tagged successfully${NC}"
}

# Function to push image
push_image() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "${RED}Error: Registry and tag are required${NC}"
        echo "Usage: $0 push [registry] [tag]"
        exit 1
    fi
    
    REGISTRY=$1
    TAG=$2
    FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}:${TAG}"
    
    echo -e "${YELLOW}Pushing image to ${FULL_IMAGE_NAME}...${NC}"
    docker push ${FULL_IMAGE_NAME}
    echo -e "${GREEN}✓ Image pushed successfully${NC}"
}

# Function to pull image
pull_image() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo -e "${RED}Error: Registry and tag are required${NC}"
        echo "Usage: $0 pull [registry] [tag]"
        exit 1
    fi
    
    REGISTRY=$1
    TAG=$2
    FULL_IMAGE_NAME="${REGISTRY}/${IMAGE_NAME}:${TAG}"
    
    echo -e "${YELLOW}Pulling image from ${FULL_IMAGE_NAME}...${NC}"
    docker pull ${FULL_IMAGE_NAME}
    echo -e "${GREEN}✓ Image pulled successfully${NC}"
}

# Function to run container
run_container() {
    echo -e "${YELLOW}Running container locally...${NC}"
    echo -e "${BLUE}Container will be available at: http://localhost:3000${NC}"
    echo -e "${BLUE}MCP endpoint: http://localhost:3000/mcp${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the container${NC}"
    
    docker run -p 3000:3000 \
        -e NODE_ENV=production \
        -e PORT=3000 \
        -e HOST=0.0.0.0 \
        --name ${IMAGE_NAME}-container \
        ${IMAGE_NAME}:${VERSION}
}

# Function to clean up
clean_up() {
    echo -e "${YELLOW}Cleaning up local images...${NC}"
    docker rmi ${IMAGE_NAME}:${VERSION} 2>/dev/null || true
    docker container rm ${IMAGE_NAME}-container 2>/dev/null || true
    echo -e "${GREEN}✓ Cleanup completed${NC}"
}

# Main script logic
case "${1:-}" in
    "build")
        build_image
        ;;
    "tag")
        tag_image "$2" "$3"
        ;;
    "push")
        push_image "$2" "$3"
        ;;
    "pull")
        pull_image "$2" "$3"
        ;;
    "run")
        run_container
        ;;
    "clean")
        clean_up
        ;;
    *)
        show_usage
        exit 1
        ;;
esac

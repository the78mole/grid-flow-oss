#!/bin/bash
set -e

echo "Running post-create setup..."

if [ -f "api-gateway/requirements.txt" ]; then
    echo "Installing API Gateway dependencies..."
    pip install -r api-gateway/requirements.txt
fi

if [ -f "ai-service/requirements.txt" ]; then
    echo "Installing AI Service dependencies..."
    pip install -r ai-service/requirements.txt
fi

if [ -f "client-web/package.json" ]; then
    echo "Installing Client Web dependencies..."
    cd client-web
    npm install
    cd ..
fi

git config --global --add safe.directory /workspace

echo ""
echo "Development environment ready!"
echo "================================"
echo "Python version: $(python --version)"
echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo ""
echo "To start the application:"
echo "  ./setup.sh"
echo ""

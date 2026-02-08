#!/bin/bash

# Validation script for GridFlow monorepo structure
# This script checks that all required files and directories are present

set -e

echo "============================================"
echo "GridFlow Structure Validation"
echo "============================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} File exists: $1"
    else
        echo -e "${RED}✗${NC} Missing file: $1"
        ERRORS=$((ERRORS + 1))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} Directory exists: $1"
    else
        echo -e "${RED}✗${NC} Missing directory: $1"
        ERRORS=$((ERRORS + 1))
    fi
}

check_executable() {
    if [ -x "$1" ]; then
        echo -e "${GREEN}✓${NC} Executable: $1"
    else
        echo -e "${YELLOW}⚠${NC} Not executable (will fix): $1"
        chmod +x "$1"
        WARNINGS=$((WARNINGS + 1))
    fi
}

echo "Checking root structure..."
check_file "README.md"
check_file "docker-compose.yml"
check_file "setup.sh"
check_executable "setup.sh"
check_file "Makefile"
check_file "LICENSE"
check_file ".gitignore"
check_file ".env.example"
echo ""

echo "Checking API Gateway..."
check_dir "api-gateway"
check_file "api-gateway/main.py"
check_file "api-gateway/Dockerfile"
check_file "api-gateway/requirements.txt"
check_file "api-gateway/.env.example"
echo ""

echo "Checking AI Service..."
check_dir "ai-service"
check_file "ai-service/main.py"
check_file "ai-service/Dockerfile"
check_file "ai-service/requirements.txt"
check_dir "ai-service/models"
echo ""

echo "Checking Client Web..."
check_dir "client-web"
check_file "client-web/package.json"
check_file "client-web/Dockerfile"
check_file "client-web/Dockerfile.dev"
check_file "client-web/next.config.js"
check_file "client-web/tsconfig.json"
check_file "client-web/.env.local.example"
check_dir "client-web/src"
check_dir "client-web/src/app"
check_file "client-web/src/app/page.tsx"
check_file "client-web/src/app/layout.tsx"
check_file "client-web/src/app/globals.css"
echo ""

echo "Checking BPMN Processes..."
check_dir "processes"
check_file "processes/README.md"
check_file "processes/pv-registration-process.bpmn"
check_dir "processes/forms"
check_file "processes/forms/pv-system-details-schema.json"
echo ""

echo "Checking Scripts..."
check_dir "scripts"
check_file "scripts/init-db.sql"
echo ""

echo "Checking Dev Container..."
check_dir ".devcontainer"
check_file ".devcontainer/devcontainer.json"
check_file ".devcontainer/Dockerfile"
check_file ".devcontainer/docker-compose.yml"
check_file ".devcontainer/post-create.sh"
check_executable ".devcontainer/post-create.sh"
echo ""

echo "============================================"
echo "Validation Summary"
echo "============================================"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ All required files and directories are present!${NC}"
else
    echo -e "${RED}✗ Found $ERRORS error(s)${NC}"
fi

if [ $WARNINGS -gt 0 ]; then
    echo -e "${YELLOW}⚠ Fixed $WARNINGS warning(s)${NC}"
fi

echo ""

if [ $ERRORS -eq 0 ]; then
    echo "Structure validation successful!"
    echo ""
    echo "Next steps:"
    echo "  1. Run: ./setup.sh"
    echo "  2. Or use: make setup"
    echo ""
    exit 0
else
    echo "Structure validation failed. Please fix the errors above."
    exit 1
fi

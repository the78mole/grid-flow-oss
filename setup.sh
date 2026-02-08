#!/bin/bash

# GridFlow Setup Script
# Initializes SpiffArena databases and loads BPMN samples

set -e

echo "============================================"
echo "GridFlow PV Registration System Setup"
echo "============================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_success "Docker and Docker Compose are installed"

# Stop any running containers
print_info "Stopping any running containers..."
docker-compose down -v 2>/dev/null || true
print_success "Containers stopped"

# Create necessary directories
print_info "Creating directories..."
mkdir -p processes/forms
mkdir -p scripts
print_success "Directories created"

# Pull required images
print_info "Pulling Docker images (this may take a few minutes)..."
docker-compose pull
print_success "Docker images pulled"

# Build custom images
print_info "Building custom Docker images..."
docker-compose build
print_success "Custom images built"

# Start PostgreSQL and Redis first
print_info "Starting PostgreSQL and Redis..."
docker-compose up -d postgres redis
print_success "Database and cache services started"

# Wait for PostgreSQL to be ready
print_info "Waiting for PostgreSQL to be ready..."
sleep 10

MAX_RETRIES=30
RETRY_COUNT=0
until docker-compose exec -T postgres pg_isready -U postgres &> /dev/null; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        print_error "PostgreSQL failed to start after ${MAX_RETRIES} attempts"
        exit 1
    fi
    echo -n "."
    sleep 2
done
echo ""
print_success "PostgreSQL is ready"

# Initialize databases (already done via init-db.sql in docker-compose)
print_success "Databases initialized via init-db.sql"

# Start SpiffArena
print_info "Starting SpiffArena..."
docker-compose up -d spiff-arena
print_success "SpiffArena started"

# Wait for SpiffArena to be ready
print_info "Waiting for SpiffArena to be ready (this may take 30-60 seconds)..."
sleep 20

MAX_RETRIES=30
RETRY_COUNT=0
until curl -f http://localhost:8080/v1.0/status &> /dev/null; do
    RETRY_COUNT=$((RETRY_COUNT + 1))
    if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
        print_error "SpiffArena failed to start after ${MAX_RETRIES} attempts"
        print_info "Check logs with: docker-compose logs spiff-arena"
        exit 1
    fi
    echo -n "."
    sleep 2
done
echo ""
print_success "SpiffArena is ready"

# Start remaining services
print_info "Starting API Gateway, AI Service, and Client Web..."
docker-compose up -d api-gateway ai-service client-web
print_success "All services started"

# Wait for services to be ready
print_info "Waiting for services to initialize..."
sleep 10

# Check service health
print_info "Checking service health..."

# Check API Gateway
if curl -f http://localhost:8000/health &> /dev/null; then
    print_success "API Gateway is healthy"
else
    print_error "API Gateway is not responding"
fi

# Check AI Service
if curl -f http://localhost:8001/health &> /dev/null; then
    print_success "AI Service is healthy"
else
    print_error "AI Service is not responding"
fi

# Check Client Web
if curl -f http://localhost:3000 &> /dev/null; then
    print_success "Client Web is healthy"
else
    print_error "Client Web is not responding (may still be building)"
fi

# Display status
echo ""
echo "============================================"
echo "Setup Complete!"
echo "============================================"
echo ""
echo "Services are running:"
echo ""
echo "  📊 SpiffArena:    http://localhost:8080"
echo "  🚀 API Gateway:   http://localhost:8000"
echo "     API Docs:      http://localhost:8000/docs"
echo "  🤖 AI Service:    http://localhost:8001"
echo "     AI Docs:       http://localhost:8001/docs"
echo "  🌐 Client Web:    http://localhost:3000"
echo ""
echo "  🗄️  PostgreSQL:    localhost:5432"
echo "     - gridflow DB     (user: gridflow, pass: gridflow)"
echo "     - spiffworkflow DB (user: spiffworkflow, pass: spiffworkflow)"
echo ""
echo "  🔴 Redis:         localhost:6379"
echo ""
echo "BPMN Process files are shared from: ./processes"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f [service-name]"
echo ""
echo "To stop all services:"
echo "  docker-compose down"
echo ""
echo "To stop and remove all data:"
echo "  docker-compose down -v"
echo ""
print_success "GridFlow is ready for development!"

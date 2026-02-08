# Development Guide for GridFlow

## Getting Started

### Quick Start
```bash
# Clone and setup
git clone https://github.com/the78mole/grid-flow-oss.git
cd grid-flow-oss
./setup.sh
```

### Using VS Code Dev Container
1. Install "Remote - Containers" extension
2. Open project in VS Code
3. Click "Reopen in Container"
4. Wait for container to build
5. Run `./setup.sh` inside container

## Architecture Overview

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Client Web    │────▶│  API Gateway    │────▶│  SpiffArena     │
│   (Next.js)     │     │   (FastAPI)     │     │  (Workflows)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
                               │
                               ▼
                        ┌─────────────────┐
                        │   AI Service    │
                        │   (PyTorch)     │
                        └─────────────────┘
                               │
                        ┌──────┴──────┐
                        ▼             ▼
                   PostgreSQL      Redis
```

## Service Details

### API Gateway (Port 8000)
**Purpose**: Main backend API, handles authentication and orchestration

**Key Files**:
- `api-gateway/main.py` - Main FastAPI application
- `api-gateway/requirements.txt` - Python dependencies
- `api-gateway/.env.example` - Environment variables

**Endpoints**:
- `GET /health` - Health check
- `GET /docs` - Swagger documentation
- `POST /auth/eid/initiate` - eID authentication (placeholder)
- `POST /auth/webauthn/register/begin` - WebAuthn registration
- `POST /api/v1/registrations` - Create PV registration

**Development**:
```bash
cd api-gateway
uvicorn main:app --reload --port 8000
```

### AI Service (Port 8001)
**Purpose**: AI-powered meter cabinet analysis using PyTorch

**Key Files**:
- `ai-service/main.py` - Main FastAPI application
- `ai-service/requirements.txt` - Python dependencies
- `ai-service/models/` - AI model storage (add .pth files here)

**Endpoints**:
- `GET /health` - Health check
- `POST /analyze/meter-cabinet` - Analyze uploaded image
- `POST /detect/components` - Detect components
- `POST /check/compliance` - Check VDE-AR-N 4105 compliance

**Development**:
```bash
cd ai-service
uvicorn main:app --reload --port 8001
```

**Adding AI Models**:
1. Place trained PyTorch models in `ai-service/models/`
2. Update `load_model()` function in `main.py`
3. Modify inference logic as needed

### Client Web (Port 3000)
**Purpose**: Frontend web application

**Key Files**:
- `client-web/src/app/page.tsx` - Homepage
- `client-web/src/app/layout.tsx` - Root layout
- `client-web/package.json` - Dependencies
- `client-web/tsconfig.json` - TypeScript config

**Development**:
```bash
cd client-web
npm install
npm run dev
```

**Building for Production**:
```bash
npm run build
npm start
```

### SpiffArena (Port 8080)
**Purpose**: BPMN workflow engine

**Configuration**:
- BPMN files are in `processes/`
- Forms are in `processes/forms/`
- Shared via Docker volume

**Accessing**:
- Web UI: http://localhost:8080
- API: http://localhost:8080/v1.0/

## Database Access

### PostgreSQL
```bash
# Using Docker Compose
docker-compose exec postgres psql -U gridflow -d gridflow

# Using psql directly
psql -h localhost -p 5432 -U gridflow -d gridflow

# Tables
# - users (authentication)
# - webauthn_credentials (passkeys)
# - pv_registrations (PV applications)
# - ai_analysis_results (AI analysis)
```

### Redis
```bash
# Using Docker Compose
docker-compose exec redis redis-cli

# Using redis-cli directly
redis-cli -h localhost -p 6379
```

## BPMN Workflow Development

### Creating a New Process
1. Create BPMN file in `processes/`
2. Use Camunda Modeler or bpmn.io
3. Add forms in `processes/forms/` (JSON Schema)
4. SpiffArena will auto-detect new files

### Sample Process Structure
```xml
<bpmn:process id="process_id">
  <bpmn:startEvent id="start"/>
  <bpmn:userTask id="task1" name="User Task"/>
  <bpmn:serviceTask id="task2" name="Service Task"/>
  <bpmn:endEvent id="end"/>
</bpmn:process>
```

## Authentication Implementation

### eID (Placeholder)
The current implementation is a placeholder. To implement real eID:

1. Choose your national eID provider
2. Register your application
3. Get client ID and secret
4. Update `api-gateway/main.py`:
   - `initiate_eid_auth()` - Redirect to eID provider
   - `eid_callback()` - Handle OAuth callback
5. Add eID library (e.g., for German eID)

### WebAuthn (Placeholder)
To implement real WebAuthn:

1. Install `py_webauthn`:
   ```bash
   pip install webauthn
   ```

2. Update `api-gateway/main.py`:
   - Generate proper challenges
   - Verify attestations and assertions
   - Store credentials securely

3. Update `client-web` with WebAuthn JavaScript API

## Testing

### API Gateway
```bash
cd api-gateway
pytest
# or
pytest tests/ -v
```

### AI Service
```bash
cd ai-service
pytest
# or with coverage
pytest --cov=. tests/
```

### Client Web
```bash
cd client-web
npm test
```

## Common Tasks

### Add a New Python Dependency
```bash
cd api-gateway  # or ai-service
pip install new-package
pip freeze > requirements.txt
```

### Add a New npm Package
```bash
cd client-web
npm install new-package
```

### Rebuild Docker Images
```bash
docker-compose build
# or for specific service
docker-compose build api-gateway
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f api-gateway

# Last 100 lines
docker-compose logs --tail=100 spiff-arena
```

### Reset Everything
```bash
# Stop and remove all containers, volumes, and networks
docker-compose down -v

# Re-run setup
./setup.sh
```

## Troubleshooting

### Port Already in Use
```bash
# Find process using port
lsof -i :8000
# or
netstat -tulpn | grep 8000

# Kill process
kill -9 <PID>
```

### Database Connection Issues
```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# Check logs
docker-compose logs postgres

# Restart database
docker-compose restart postgres
```

### SpiffArena Not Starting
```bash
# Check logs
docker-compose logs spiff-arena

# Check database connectivity
docker-compose exec spiff-arena ping -c 3 postgres

# Rebuild
docker-compose build spiff-arena
docker-compose up -d spiff-arena
```

## Code Style

### Python
- Use Black for formatting: `black .`
- Use pylint for linting: `pylint **/*.py`
- Follow PEP 8

### TypeScript/JavaScript
- Use Prettier: `npx prettier --write .`
- Use ESLint: `npm run lint`

## Environment Variables

### Development
Copy example files:
```bash
cp api-gateway/.env.example api-gateway/.env
cp client-web/.env.local.example client-web/.env.local
cp .env.example .env
```

### Production
Never commit actual `.env` files. Use secrets management:
- Docker Swarm secrets
- Kubernetes secrets
- AWS Secrets Manager
- Azure Key Vault

## Performance Tips

1. **Use Redis for caching**
   ```python
   import redis
   r = redis.from_url(os.getenv("REDIS_URL"))
   r.setex("key", 3600, "value")
   ```

2. **Database connection pooling**
   - Already configured in SQLAlchemy

3. **AI Model optimization**
   - Use ONNX for production
   - Enable GPU if available
   - Batch predictions

## Security Considerations

1. **Change default passwords** in production
2. **Use HTTPS** with proper certificates
3. **Implement rate limiting** (use Redis)
4. **Validate all inputs** (Pydantic models)
5. **Use prepared statements** (SQLAlchemy ORM)
6. **Enable CORS** only for trusted origins
7. **Store secrets** in environment variables, not code

## Deployment

### Docker Swarm
```bash
docker swarm init
docker stack deploy -c docker-compose.yml gridflow
```

### Kubernetes
Convert with Kompose:
```bash
kompose convert
kubectl apply -f .
```

### Cloud Providers
- AWS: ECS, EKS, or App Runner
- Azure: AKS or Container Instances
- GCP: GKE or Cloud Run

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Run tests
5. Submit pull request

## Resources

- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [Next.js Docs](https://nextjs.org/docs)
- [PyTorch Docs](https://pytorch.org/docs/)
- [SpiffWorkflow Docs](https://www.spiffworkflow.org/)
- [BPMN 2.0 Spec](https://www.omg.org/spec/BPMN/2.0/)

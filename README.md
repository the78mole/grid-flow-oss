# GridFlow - PV Registration System

An open-source BPMN orchestration platform for automated grid connection (VDE-AR-N 4105). Features eID/Passkey authentication, AI-based meter cabinet validation, and dynamic VNB process mapping. Built with SpiffWorkflow, FastAPI, and Next.js.

## 🏗️ Architecture

This is a production-ready monorepo with the following structure:

```
grid-flow-oss/
├── api-gateway/          # FastAPI backend service
├── ai-service/           # PyTorch-based AI service for meter cabinet analysis
├── client-web/           # Next.js frontend application
├── processes/            # BPMN 2.0 workflow definitions
├── .devcontainer/        # VS Code dev container configuration
├── scripts/              # Database and setup scripts
├── docker-compose.yml    # Docker Compose orchestration
└── setup.sh             # One-command setup script
```

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- (Optional) VS Code with Remote Containers extension

### Setup

1. Clone the repository:
```bash
git clone https://github.com/the78mole/grid-flow-oss.git
cd grid-flow-oss
```

2. Run the setup script:
```bash
./setup.sh
```

The script will:
- Pull and build all Docker images
- Initialize PostgreSQL databases
- Start SpiffArena, PostgreSQL, Redis, and all services
- Load sample BPMN workflows

3. Access the applications:
- **Client Web**: http://localhost:3000
- **API Gateway**: http://localhost:8000 (Docs: http://localhost:8000/docs)
- **AI Service**: http://localhost:8001 (Docs: http://localhost:8001/docs)
- **SpiffArena**: http://localhost:8080

## 🛠️ Development

### Using Dev Container (Recommended)

1. Open the project in VS Code
2. Click "Reopen in Container" when prompted
3. The dev container includes:
   - Python 3.12
   - Node.js 20
   - Docker-outside-of-Docker
   - All necessary VS Code extensions

### Running Services Individually

```bash
# API Gateway
cd api-gateway
uvicorn main:app --reload --port 8000

# AI Service
cd ai-service
uvicorn main:app --reload --port 8001

# Client Web
cd client-web
npm run dev
```

## 📋 Services

### API Gateway (FastAPI)
- RESTful API for PV registration
- Authentication (eID & WebAuthn/Passkey placeholders)
- Integration with SpiffArena workflows
- Proxy to AI service

### AI Service (PyTorch)
- AI-based meter cabinet validation
- VDE-AR-N 4105 compliance checking
- Component detection and analysis

### Client Web (Next.js)
- Modern React-based UI
- Server-side rendering
- Responsive design

### SpiffArena
- BPMN 2.0 workflow execution
- Process management and monitoring
- Form rendering

## 🔐 Authentication

The system includes placeholder implementations for:

### eID Authentication
- Initiate eID flow: `POST /auth/eid/initiate`
- Handle callback: `POST /auth/eid/callback`

### WebAuthn/Passkey Authentication
- Register credential: `POST /auth/webauthn/register/begin` & `/complete`
- Authenticate: `POST /auth/webauthn/authenticate/begin` & `/complete`

**Note**: These are placeholders. Implement actual authentication logic based on your national eID system and WebAuthn library.

## 🔄 BPMN Workflows

BPMN process definitions are stored in the `processes/` directory and shared with SpiffArena via Docker volumes.

### Sample Process: PV Registration
1. User enters PV system details
2. User uploads meter cabinet photos
3. AI analyzes images for compliance
4. If compliant, submit to VNB (grid operator)
5. Wait for VNB approval
6. Complete registration

## 💡 Features

- ✅ Production-ready monorepo structure
- ✅ Docker Compose orchestration
- ✅ Dev Container with Docker-outside-of-Docker
- ✅ Python 3.12 & Node.js 20
- ✅ SpiffArena BPMN workflow engine
- ✅ PostgreSQL & Redis
- ✅ eID authentication placeholders
- ✅ WebAuthn/Passkey authentication placeholders
- ✅ AI-based meter cabinet validation
- ✅ Shared volumes for BPMN files
- ✅ One-command setup script
- ✅ API documentation (Swagger/OpenAPI)

## 📞 Support

For issues and questions, please open an issue on GitHub.

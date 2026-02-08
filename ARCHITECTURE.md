# GridFlow Architecture

## System Overview

GridFlow is a production-ready monorepo for a PV (Photovoltaic) registration system following the German VDE-AR-N 4105 standard for grid connections. The system uses BPMN 2.0 workflows to orchestrate the registration process, AI for automated compliance checking, and modern web technologies for the user interface.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet/Users                        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    Client Web (Next.js)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Landing    │  │     Auth     │  │ Registration │      │
│  │     Page     │  │ eID/WebAuthn │  │    Forms     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTP/REST
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  API Gateway (FastAPI)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  Auth Layer  │  │   Business   │  │ Integration  │      │
│  │ eID/WebAuthn │  │    Logic     │  │    Layer     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└───────┬─────────────────┬───────────────────┬───────────────┘
        │                 │                   │
        ▼                 ▼                   ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  AI Service  │  │  SpiffArena  │  │  PostgreSQL  │
│  (PyTorch)   │  │   (BPMN)     │  │  & Redis     │
│              │  │              │  │              │
│ ┌──────────┐ │  │ ┌──────────┐ │  │ ┌──────────┐ │
│ │  Image   │ │  │ │ Process  │ │  │ │  Users   │ │
│ │ Analysis │ │  │ │ Engine   │ │  │ │ Workflow │ │
│ │          │ │  │ │          │ │  │ │  Cache   │ │
│ └──────────┘ │  │ └──────────┘ │  │ └──────────┘ │
└──────────────┘  └──────────────┘  └──────────────┘
```

## Component Details

### 1. Client Web (Next.js 14)
**Purpose**: User-facing web application

**Technology Stack**:
- Next.js 14 with App Router
- React 18
- TypeScript
- Server-Side Rendering (SSR)
- Tailwind CSS (optional)

**Key Features**:
- Landing page with system overview
- Authentication UI (eID and WebAuthn)
- PV registration forms
- Dashboard for tracking applications
- Responsive design

**Communication**:
- Calls API Gateway via HTTP/REST
- Environment variable for API URL

### 2. API Gateway (FastAPI)
**Purpose**: Central backend service, orchestrates all operations

**Technology Stack**:
- FastAPI (Python 3.12)
- Pydantic for validation
- SQLAlchemy for ORM
- asyncpg for PostgreSQL
- redis-py for caching

**Responsibilities**:
1. **Authentication & Authorization**
   - eID integration (placeholder)
   - WebAuthn/Passkey (placeholder)
   - JWT token management
   
2. **Business Logic**
   - PV registration workflow initiation
   - Data validation
   - User management
   
3. **Integration**
   - Proxy requests to AI Service
   - Trigger SpiffArena workflows
   - Cache management (Redis)

**Endpoints**:
```
/health                              - Health check
/auth/eid/*                         - eID authentication
/auth/webauthn/*                    - WebAuthn authentication
/api/v1/registrations               - PV registrations
/api/v1/analyze/meter-cabinet       - AI analysis proxy
```

### 3. AI Service (PyTorch)
**Purpose**: AI-powered meter cabinet validation

**Technology Stack**:
- FastAPI (Python 3.12)
- PyTorch 2.1
- Pillow for image processing
- NumPy for numerical operations

**Capabilities**:
1. **Image Analysis**
   - Meter cabinet detection
   - Component identification
   - Quality assessment
   
2. **Compliance Checking**
   - VDE-AR-N 4105 validation
   - Safety verification
   - Issue detection
   
3. **Recommendations**
   - Automated suggestions
   - Risk assessment

**Model Architecture** (placeholder):
- Input: Images (224x224)
- Feature extraction: ResNet/EfficientNet
- Output: Components, compliance status, confidence scores

### 4. SpiffArena (BPMN Workflow Engine)
**Purpose**: Orchestrate business processes

**Technology Stack**:
- SpiffWorkflow
- Flask backend
- PostgreSQL for persistence

**Workflow Types**:
1. **PV Registration Process**
   - User input collection
   - Document upload
   - AI validation
   - VNB submission
   - Approval tracking

2. **Manual Review Process**
   - Triggered on AI non-compliance
   - Expert review workflow
   - Decision recording

**Integration Points**:
- Service tasks call API Gateway
- User tasks render in SpiffArena UI
- Forms use JSON Schema

### 5. PostgreSQL Database
**Purpose**: Persistent data storage

**Databases**:
1. **gridflow** - Application data
   - users
   - webauthn_credentials
   - pv_registrations
   - ai_analysis_results

2. **spiffworkflow** - Workflow data
   - process_instances
   - tasks
   - variables

**Key Features**:
- ACID compliance
- JSON/JSONB support
- Full-text search
- Spatial data (PostGIS optional)

### 6. Redis Cache
**Purpose**: High-performance caching and session storage

**Use Cases**:
- Session management
- API response caching
- Rate limiting
- Pub/Sub messaging
- Job queues

## Data Flow

### User Registration Flow

```
1. User submits registration form
   Client Web → API Gateway
   
2. API Gateway validates and stores
   API Gateway → PostgreSQL
   
3. API Gateway initiates workflow
   API Gateway → SpiffArena (POST /process-instances)
   
4. Workflow requests user to upload images
   SpiffArena → User Task
   
5. User uploads meter cabinet images
   Client Web → API Gateway → AI Service
   
6. AI Service analyzes images
   AI Service → Returns analysis results
   
7. API Gateway stores results
   API Gateway → PostgreSQL
   
8. Workflow evaluates compliance
   SpiffArena → Gateway (check compliance)
   
9a. If compliant: Submit to VNB
    SpiffArena → External VNB API
    
9b. If not compliant: Manual review
    SpiffArena → Manual Review Task
    
10. Track approval status
    SpiffArena → Polling/Webhook from VNB
    
11. Complete registration
    SpiffArena → End Event
    User notified via email/SMS
```

## Security Architecture

### Authentication
1. **eID (Electronic Identity)**
   - OAuth 2.0 / OpenID Connect
   - Integration with national eID providers
   - High assurance level

2. **WebAuthn (Passkeys)**
   - FIDO2 standard
   - Biometric or security key
   - Phishing-resistant

### Authorization
- Role-Based Access Control (RBAC)
- JWT tokens with claims
- Scoped permissions

### Data Protection
- Encrypted at rest (PostgreSQL TDE)
- Encrypted in transit (TLS 1.3)
- PII anonymization options
- GDPR compliance ready

### Network Security
- CORS configured
- Rate limiting (Redis)
- Input validation (Pydantic)
- SQL injection prevention (ORM)

## Scalability

### Horizontal Scaling
- **API Gateway**: Stateless, scale with load balancer
- **AI Service**: Queue-based processing
- **Client Web**: CDN + multiple instances
- **Database**: Read replicas, connection pooling

### Vertical Scaling
- **AI Service**: GPU acceleration
- **Database**: More RAM for caching
- **Redis**: Cluster mode

### Performance Optimization
1. **Caching Strategy**
   - API responses (Redis, 5-60 min TTL)
   - Database query results
   - Static assets (CDN)

2. **Database**
   - Indexes on frequently queried columns
   - Materialized views for reports
   - Connection pooling

3. **AI Service**
   - Model quantization
   - Batch inference
   - Result caching

## Deployment Architecture

### Development
```
Docker Compose on local machine
All services on localhost
Shared volumes for hot-reloading
```

### Staging
```
Docker Swarm or Kubernetes
Separate environment
Similar to production
```

### Production
```
Kubernetes (recommended)
├── Ingress (nginx/traefik)
├── API Gateway (2+ pods)
├── AI Service (2+ pods with GPU)
├── Client Web (2+ pods)
├── SpiffArena (2+ pods)
├── PostgreSQL (managed service or StatefulSet)
└── Redis (managed service or StatefulSet)
```

## Monitoring & Observability

### Metrics
- **Application**: Prometheus + Grafana
- **System**: Node Exporter
- **Database**: PostgreSQL Exporter

### Logging
- **Centralized**: ELK Stack or Loki
- **Structured**: JSON format
- **Levels**: DEBUG, INFO, WARNING, ERROR

### Tracing
- **Distributed**: Jaeger or Zipkin
- **Correlation IDs**: Track requests across services

### Health Checks
- `/health` endpoints on all services
- Kubernetes liveness/readiness probes
- Synthetic monitoring

## Disaster Recovery

### Backup Strategy
1. **Database**: Daily full + hourly incremental
2. **BPMN Files**: Git repository
3. **AI Models**: Object storage (S3/GCS)
4. **Configs**: Encrypted in Git

### Recovery Time Objective (RTO)
- Database: 1 hour
- Services: 15 minutes
- Total system: 2 hours

### Recovery Point Objective (RPO)
- Database: 1 hour
- BPMN/Code: Last commit

## Future Enhancements

1. **Microservices**
   - Split API Gateway into smaller services
   - Event-driven architecture (Kafka/RabbitMQ)

2. **Advanced AI**
   - Computer vision for document OCR
   - Anomaly detection
   - Predictive maintenance

3. **Integration**
   - More VNB APIs
   - Smart meter integration
   - E-mobility platforms

4. **Mobile App**
   - React Native or Flutter
   - Push notifications
   - Offline support

## Technology Decisions

### Why FastAPI?
- Modern async framework
- Auto-generated OpenAPI docs
- Type hints and validation
- High performance

### Why Next.js?
- SSR for better SEO
- Great developer experience
- TypeScript support
- Optimized for production

### Why PyTorch?
- Industry standard for AI
- Large ecosystem
- Good tooling
- Production-ready (ONNX)

### Why SpiffWorkflow?
- BPMN 2.0 compliance
- Python-based (same stack)
- Open source
- Active community

### Why PostgreSQL?
- Mature and reliable
- JSON support
- Full-text search
- Strong ecosystem

### Why Redis?
- Fast in-memory storage
- Multiple data structures
- Pub/Sub support
- Proven at scale

## Conclusion

GridFlow provides a solid foundation for a PV registration system with:
- ✅ Modern, scalable architecture
- ✅ Security best practices
- ✅ Production-ready setup
- ✅ Comprehensive documentation
- ✅ DevOps friendly

The architecture is designed to be:
- **Maintainable**: Clear separation of concerns
- **Scalable**: Horizontal and vertical scaling options
- **Secure**: Multiple layers of security
- **Observable**: Built-in monitoring and logging
- **Extensible**: Easy to add new features

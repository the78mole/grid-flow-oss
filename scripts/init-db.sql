-- Initialize databases for GridFlow PV Registration System

-- Create database users
CREATE USER gridflow WITH PASSWORD 'gridflow';
CREATE USER spiffworkflow WITH PASSWORD 'spiffworkflow';

-- Create databases
CREATE DATABASE gridflow OWNER gridflow;
CREATE DATABASE spiffworkflow OWNER spiffworkflow;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE gridflow TO gridflow;
GRANT ALL PRIVILEGES ON DATABASE spiffworkflow TO spiffworkflow;

-- Connect to gridflow database and create tables
\c gridflow;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255),
    eid_identifier VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- WebAuthn credentials table
CREATE TABLE IF NOT EXISTS webauthn_credentials (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    credential_id TEXT UNIQUE NOT NULL,
    public_key TEXT NOT NULL,
    sign_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- PV registrations table
CREATE TABLE IF NOT EXISTS pv_registrations (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    workflow_instance_id VARCHAR(255) UNIQUE,
    system_capacity DECIMAL(10, 2),
    installation_address JSONB,
    status VARCHAR(50) DEFAULT 'initiated',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AI analysis results table
CREATE TABLE IF NOT EXISTS ai_analysis_results (
    id SERIAL PRIMARY KEY,
    registration_id INTEGER REFERENCES pv_registrations(id) ON DELETE CASCADE,
    analysis_id VARCHAR(255) UNIQUE NOT NULL,
    image_path TEXT,
    confidence DECIMAL(5, 4),
    is_compliant BOOLEAN,
    predictions JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Grant permissions to gridflow user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gridflow;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gridflow;

-- Create indexes
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_webauthn_user_id ON webauthn_credentials(user_id);
CREATE INDEX idx_registrations_user_id ON pv_registrations(user_id);
CREATE INDEX idx_registrations_status ON pv_registrations(status);
CREATE INDEX idx_analysis_registration_id ON ai_analysis_results(registration_id);

COMMENT ON TABLE users IS 'User accounts with eID and WebAuthn support';
COMMENT ON TABLE webauthn_credentials IS 'WebAuthn/Passkey credentials for passwordless authentication';
COMMENT ON TABLE pv_registrations IS 'PV system registration applications';
COMMENT ON TABLE ai_analysis_results IS 'AI-powered meter cabinet analysis results';

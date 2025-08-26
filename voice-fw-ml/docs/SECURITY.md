# Security guide
# Security Guide

## Authentication
```bash
# JWT token authentication
# Username/password login required
# API key support for automated access
```

## Configuration
```yaml
# configs/security/auth.yaml
auth:
  jwt_secret_key: "your-secret-key"
  jwt_expiration_hours: 24
  max_failed_attempts: 5
  lockout_duration_minutes: 30
```

## Data Protection
- **Encryption at Rest**: AES-256 for sensitive data
- **Encryption in Transit**: TLS 1.3 for all connections
- **PII Anonymization**: Phone numbers hashed for ML
- **Audit Logging**: All operations logged

## Network Security
```yaml
# nginx.conf
- SSL termination
- Rate limiting
- Security headers
- IP whitelisting
```

## Database Security
```sql
-- Row-level security
CREATE POLICY tenant_isolation ON cdr_data
USING (tenant_id = current_setting('app.current_tenant'));

-- Encrypted columns
ALTER TABLE cdr_data ADD COLUMN encrypted_data bytea;
```

## API Security
```python
# Rate limiting
@limiter.limit("1000 per hour")
@require_auth
def predict_fraud():
    pass
```

## Security Checklist
- [ ] Change default passwords
- [ ] Enable SSL certificates
- [ ] Configure firewall rules
- [ ] Set up audit logging
- [ ] Regular security updates
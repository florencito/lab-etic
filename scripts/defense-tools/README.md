# Defense Tools

🛡️ **Security hardening and cleanup utilities**

## Scripts in this directory:

### `harden_server.sh`
- **Purpose**: Comprehensive server security hardening
- **Target**: Victim-Server (192.168.56.10)
- **Features**:
  - UFW firewall configuration
  - Apache security hardening
  - System-level security measures
  - Access control implementation
- **Usage**: Run on Victim-Server after baseline testing

### `cleanup_malware.sh`
- **Purpose**: Remove malware and restore clean state
- **Target**: Infected systems
- **Features**:
  - Malware detection and removal
  - System integrity restoration
  - Log cleanup and analysis
  - Security verification
- **Usage**: Run after malware attack demonstrations

## Implementation Guidelines:
- Apply after completing baseline attack testing
- Document changes for comparison analysis
- Verify effectiveness against repeat attacks
- Maintain configuration backups

## Security Measures:
- Firewall rule implementation
- Web server hardening
- Service configuration updates
- Access control enforcement
- Monitoring enhancement

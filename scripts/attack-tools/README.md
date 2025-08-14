# Attack Tools

⚠️ **WARNING**: These tools are for educational purposes only in controlled environments.

## Scripts in this directory:

### `keylogger_attack.sh`
- **Purpose**: Deploy keylogger attack on target system
- **Target**: Victim-Server (192.168.56.10)
- **Requirements**: Kali Linux attacker VM
- **Usage**: Run from Attacker-Kali VM

### `dos_script.sh`
- **Purpose**: Standard Denial of Service attack
- **Target**: Victim-Server web services
- **Impact**: Test server availability under load
- **Usage**: Execute with target IP parameter

### `aggressive_dos.sh`
- **Purpose**: High-intensity DoS attack
- **Target**: Victim-Server infrastructure
- **Impact**: Stress test server resources
- **Usage**: Use for hardened server testing

### `demo_malware_attack.sh`
- **Purpose**: Malware deployment and propagation
- **Target**: Web server with file upload capabilities
- **Impact**: Demonstrate infection vectors
- **Usage**: Automated malware deployment

## Safety Guidelines:
- Only use in isolated lab environment
- Never target systems without authorization
- Monitor IDS detection during execution
- Clean up after testing sessions

## Evidence Collection:
- Screenshots of attack execution
- IDS detection alerts
- System impact measurements
- Network traffic analysis

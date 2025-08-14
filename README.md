# Ethical Hacking Final Project - Cybersecurity Lab

[![Academic](https://img.shields.io/badge/Type-Academic%20Project-blue.svg)](https://github.com/topics/academic)
[![Ethical Hacking](https://img.shields.io/badge/Focus-Ethical%20Hacking-red.svg)](https://github.com/topics/ethical-hacking)
[![VirtualBox](https://img.shields.io/badge/Platform-VirtualBox-orange.svg)](https://virtualbox.org)

> **⚠️ DISCLAIMER:** This project is for educational purposes only. All activities are performed in a controlled, isolated virtual environment for academic learning about cybersecurity concepts.

## 📋 Project Overview

This project demonstrates various cybersecurity concepts through controlled ethical hacking exercises. It implements a complete penetration testing scenario with vulnerability assessment, attack simulation, intrusion detection, and security hardening.

### 🎯 Learning Objectives
- Deploy vulnerable web services and understand common security weaknesses
- Install and configure Intrusion Detection Systems (IDS)
- Execute controlled penetration testing attacks
- Implement security hardening measures
- Analyze and compare security postures before and after hardening

## 🏗️ Infrastructure Setup

### Virtual Machine Architecture
The project uses three VirtualBox virtual machines in an isolated network environment:

| VM Name | Operating System | IP Address | Role |
|---------|-----------------|------------|------|
| **Victim-Server** | Ubuntu Server 22.04 | 192.168.56.10 | Target system with intentionally vulnerable Apache web server |
| **Sensor-IDS** | Ubuntu Server 22.04 + Snort | 192.168.56.11 | Intrusion Detection System for monitoring attacks |
| **Attacker-Kali** | Kali Linux | 192.168.56.12 | Penetration testing platform |

### Network Configuration
- **Network Type**: NAT + Host-Only Adapter
- **Host-Only Network**: 192.168.56.0/24
- **Isolation**: Complete isolation from production networks
- **Internet Access**: Available via NAT adapter when needed

## 📚 Project Tasks & Components

### Core Technical Tasks (85% weight)

#### ✅ Task 1: Deploy Vulnerable Apache Web Server (10%)
- Install Apache2 with PHP support
- Create intentionally vulnerable PHP applications
- Implement XSS and command injection vulnerabilities
- Configure minimal security (baseline for comparison)

#### ✅ Task 2: Install and Configure IDS - Snort (10%)
- Deploy Snort IDS v2.9.20 with custom detection rules
- Configure network monitoring for 192.168.56.0/24
- Implement real-time threat detection
- Create custom rules for web attacks, DoS, and reconnaissance

#### 🔄 Task 3: Keylogger Attack Implementation (10%)
- Deploy keylogging techniques from Kali Linux
- Target victim server user sessions
- Capture and analyze keystroke data
- Document IDS detection capabilities

#### 🔄 Task 4: DDoS Attack Simulation (5%)
- Execute Distributed Denial of Service attacks
- Test server availability under attack
- Monitor resource consumption and service degradation
- Verify IDS detection and alerting

#### 🔄 Task 5: Malware Deployment and Propagation (10%)
- Plant malware on the target server
- Demonstrate infection propagation via web visits
- Test various malware types and delivery methods
- Document infection vectors and impact

#### 🔄 Task 6: IDS Verification and Analysis (10%)
- Validate Snort detection for all attack types
- Analyze alert patterns and false positives
- Fine-tune detection rules for optimal performance
- Document monitoring effectiveness

#### 🔄 Task 7: Security Hardening Implementation (10%)
- Reinstall server with security-first approach
- Configure and activate internal firewall (UFW)
- Harden Apache configuration
- Implement access controls and security headers
- Apply system-level security measures

#### 🔄 Task 8: Comparative Attack Analysis (10%)
- Repeat all attacks against hardened server
- Document attack success/failure rates
- Compare detection capabilities
- Measure security improvement effectiveness

#### 📊 Task 9: Comprehensive Reporting (10%)
- Detailed attack methodology documentation
- Before/after security comparison tables
- IDS effectiveness analysis
- Recommendations for security improvements

## 🛠️ Project Structure

```
lab-etic-repo/
├── 📁 docs/                    # All project documentation
├── 📁 scripts/                 # Executable tools and scripts
│   ├── attack-tools/           # Penetration testing scripts
│   ├── defense-tools/          # Security hardening scripts
│   └── analysis-tools/         # Monitoring and analysis tools
├── 📁 configs/                 # Configuration files
│   ├── snort/                  # IDS configuration
│   └── apache/                 # Web server configuration
├── 📁 vm-setup/                # Virtual machine setup guides
├── 📁 evidence/                # Attack evidence and screenshots
│   ├── before-hardening/       # Vulnerable server evidence
│   ├── after-hardening/        # Hardened server evidence
│   └── ids-detection/          # IDS monitoring results
└── 📁 logs/                    # Log files and analysis
    ├── attack-logs/            # Attack execution logs
    ├── ids-logs/               # IDS detection logs
    └── system-logs/            # System monitoring logs
```

### Tools and Scripts

#### Attack Tools (`scripts/attack-tools/`)
- `keylogger_attack.sh` - Keylogger deployment and execution
- `dos_script.sh` - Standard DoS attack implementation
- `aggressive_dos.sh` - High-intensity DoS testing
- `demo_malware_attack.sh` - Malware deployment automation

#### Defense Tools (`scripts/defense-tools/`)
- `harden_server.sh` - Server security hardening automation
- `cleanup_malware.sh` - Malware removal and system cleanup

#### Analysis Tools (`scripts/analysis-tools/`)
- `check_malware_infection.py` - Infection detection and analysis
- `transfer_scripts.ps1` - Script deployment helper

## 📖 Documentation Structure

| Document | Purpose |
|----------|---------|
| `PROJECT_DOCUMENTATION.md` | Detailed technical progress and step-by-step documentation |
| `AGENTS.md` | Task breakdown and project requirements |
| `EXECUTION_GUIDE.md` | Step-by-step attack execution procedures |
| `MALWARE_DEMONSTRATION_GUIDE.md` | Malware testing and analysis procedures |
| `SCRIPT_GUIDE.md` | Tool usage and script documentation |
| `hardened-server-summary.md` | Security hardening implementation details |

## 🚀 Quick Start Guide

### Prerequisites
- VirtualBox installed and configured
- Ubuntu Server 22.04 ISO
- Kali Linux ISO
- Minimum 8GB RAM available for VMs
- 50GB+ disk space

### Setup Process
1. **Create Virtual Machines**
   ```bash
   # Follow VM creation guidelines in PROJECT_DOCUMENTATION.md
   # Configure NAT + Host-Only networking
   ```

2. **Network Configuration**
   ```bash
   # Configure Host-Only network: 192.168.56.0/24
   # Assign static IPs to all VMs
   ```

3. **Install Base Systems**
   ```bash
   # Install Ubuntu Server on Victim and IDS VMs
   # Install Kali Linux on Attacker VM
   ```

4. **Deploy Services**
   ```bash
   # Run initial setup scripts
   # Verify network connectivity
   ```

### Execution Workflow
1. **Start with security baseline** (vulnerable server)
2. **Deploy IDS monitoring** (Snort configuration)
3. **Execute attacks sequentially** (following EXECUTION_GUIDE.md)
4. **Monitor and document** IDS responses
5. **Implement hardening** measures
6. **Repeat attacks** and compare results
7. **Compile comprehensive report**

## 🔍 Monitoring and Analysis

### IDS Monitoring Commands
```bash
# SSH to Sensor-IDS VM
ssh sensor-admin@192.168.56.11

# Real-time alert monitoring
sudo tail -f /var/log/snort/snort.alert.fast

# Attack-specific searches
sudo grep "Command Injection" /var/log/snort/snort.alert.fast
sudo grep "DoS Attack" /var/log/snort/snort.alert.fast
```

### Log Analysis Locations
- **Web Server**: `/var/log/apache2/access.log`
- **System Auth**: `/var/log/auth.log`
- **Snort Alerts**: `/var/log/snort/snort.alert.fast`
- **System Activity**: `/var/log/syslog`

## 📊 Expected Outcomes

### Security Assessment Results
- **Baseline Security**: High vulnerability, successful attacks
- **Post-Hardening**: Reduced attack surface, improved detection
- **IDS Effectiveness**: Comprehensive attack detection and alerting
- **Comparative Analysis**: Quantified security improvement metrics

### Learning Deliverables
- Understanding of common web vulnerabilities
- IDS deployment and configuration experience
- Penetration testing methodology knowledge
- Security hardening best practices
- Incident response and forensics skills

## ⚖️ Ethical Guidelines

### Controlled Environment
- All activities performed in isolated virtual networks
- No impact on production systems or external networks
- Complete containment of all attack scenarios

### Educational Purpose
- Academic project for cybersecurity education
- Understanding defensive security through offensive techniques
- Preparation for cybersecurity career roles

### Responsible Disclosure
- Documentation of all vulnerabilities and fixes
- Knowledge sharing for defensive improvement
- Ethical application of penetration testing skills

## 🤝 Contributing

This is an academic project, but feedback and suggestions are welcome:
- Document improvements
- Additional attack scenarios
- Enhanced detection rules
- Security hardening recommendations

## 📜 License

This project is for educational use only. All tools and techniques should be used responsibly and only in authorized testing environments.

---

**⚠️ IMPORTANT NOTICE**: This project contains tools and techniques for educational cybersecurity purposes. Users are responsible for ensuring compliance with local laws and institutional policies. Never use these techniques against systems you do not own or have explicit authorization to test.

---

*Last Updated: August 2025 - Academic Final Project*

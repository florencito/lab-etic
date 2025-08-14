# Project Structure Guide

## Directory Organization

```
lab-etic-repo/
│
├── README.md                          # Main project documentation
├── PROJECT_STRUCTURE.md              # This file - directory guide
│
├── 📁 docs/                          # All documentation files
│   ├── AGENTS.md                     # Task requirements and breakdown
│   ├── PROJECT_DOCUMENTATION.md     # Detailed technical progress
│   ├── EXECUTION_GUIDE.md           # Step-by-step attack procedures
│   ├── MALWARE_DEMONSTRATION_GUIDE.md # Malware testing procedures
│   ├── SCRIPT_GUIDE.md              # Tool usage documentation
│   └── hardened-server-summary.md   # Security hardening details
│
├── 📁 scripts/                       # All executable scripts
│   ├── 📁 attack-tools/              # Penetration testing scripts
│   │   ├── keylogger_attack.sh       # Keylogger deployment
│   │   ├── dos_script.sh             # Standard DoS attack
│   │   ├── aggressive_dos.sh         # High-intensity DoS
│   │   └── demo_malware_attack.sh    # Malware deployment
│   │
│   ├── 📁 defense-tools/             # Security and cleanup scripts
│   │   ├── harden_server.sh          # Server security hardening
│   │   └── cleanup_malware.sh        # Malware removal
│   │
│   └── 📁 analysis-tools/            # Analysis and monitoring tools
│       ├── check_malware_infection.py # Infection detection
│       └── transfer_scripts.ps1      # Script deployment helper
│
├── 📁 configs/                       # Configuration files
│   ├── 📁 snort/                     # IDS configuration
│   │   └── (Snort rules and config files)
│   └── 📁 apache/                    # Web server configuration
│       └── (Apache config and vulnerable files)
│
├── 📁 vm-setup/                      # Virtual machine setup files
│   └── (VM configuration scripts and guides)
│
├── 📁 evidence/                      # Attack evidence and screenshots
│   ├── 📁 before-hardening/         # Pre-security evidence
│   ├── 📁 after-hardening/          # Post-security evidence
│   └── 📁 ids-detection/            # IDS detection evidence
│
└── 📁 logs/                         # Log files and analysis
    ├── 📁 attack-logs/              # Attack execution logs
    ├── 📁 ids-logs/                 # IDS detection logs
    └── 📁 system-logs/              # System monitoring logs
```

## Usage Guidelines

### 📚 Documentation (`/docs/`)
- Start with `README.md` for project overview
- Use `AGENTS.md` for task requirements
- Follow `EXECUTION_GUIDE.md` for attack procedures
- Reference `SCRIPT_GUIDE.md` for tool usage

### 🛠️ Scripts (`/scripts/`)
- **Attack Tools**: Use only in controlled lab environment
- **Defense Tools**: Apply security measures and cleanup
- **Analysis Tools**: Monitor and analyze attack results

### ⚙️ Configuration (`/configs/`)
- Store IDS rules and web server configurations
- Version control configuration changes
- Document configuration modifications

### 🖼️ Evidence (`/evidence/`)
- Organize screenshots by attack phase
- Include before/after comparisons
- Document IDS detection results

### 📊 Logs (`/logs/`)
- Collect all attack and defense logs
- Maintain chronological organization
- Preserve for final report analysis

## File Naming Conventions

### Scripts
- Use descriptive names: `keylogger_attack.sh`
- Include tool type: `harden_server.sh`
- Use underscores for separation

### Documentation
- Use uppercase for main docs: `README.md`
- Use descriptive names: `EXECUTION_GUIDE.md`
- Include version dates when updated

### Evidence Files
- Format: `YYYY-MM-DD_task-description_evidence-type`
- Example: `2025-08-13_dos-attack_network-traffic.png`
- Group by task/attack type

## Best Practices

### Version Control
- Commit after each major task completion
- Use descriptive commit messages
- Tag important milestones

### Security
- Keep attack tools isolated to lab environment
- Never run outside authorized testing
- Clean up after testing sessions

### Documentation
- Update progress regularly
- Include screenshots for evidence
- Maintain detailed logs for report writing

---

*This structure supports academic project requirements and professional cybersecurity practices.*

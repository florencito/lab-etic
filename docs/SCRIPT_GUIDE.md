# 🎯 Ethical Hacking Lab - Script Guide

**Student:** [Your Name]  
**Date:** August 13, 2025

---

## 📋 Script Mapping to Teacher Requirements

I've created specific scripts that directly address each of your teacher's required tasks:

### ✅ **Tasks Already Completed:**
- ✅ **Task 1: Deploy Apache web server with no security (10%)** - DONE
- ✅ **Task 2: Install an IDS (Snort) (10%)** - DONE  

### 🚀 **Scripts for Remaining Tasks:**

### 1️⃣ **Task 3: Perform a keylogger attack (10%)**
- **Script to Use:** `keylogger_attack.sh`
- **What it does:**
  - Deploys both Python and Bash-based keyloggers via command injection
  - Captures system information and simulated keystrokes
  - Sets up network exfiltration capabilities
  - Demonstrates persistence methods (cron jobs)
  - Verifies keylogger data collection

### 2️⃣ **Task 4: Execute a DDOS attack (5%)**
- **Script to Use:** `dos_script.sh`
- **What it does:**
  - Performs HTTP floods to overload the web server
  - Tests TCP connection exhaustion
  - Executes resource-intensive commands via command injection
  - Conducts network layer attacks (ICMP/UDP floods)
  - Monitors and verifies server availability impact
  - Tests service recovery after attacks

### 3️⃣ **Task 5: Plant malware and demonstrate infection (10%)**
- **Script to Use:** `malware_attack.sh`
- **What it does:**
  - Deploys educational "malware" on the victim server
  - Creates multiple web-based infection vectors
  - Demonstrates cross-system infection via:
    - XSS attacks
    - Drive-by downloads
    - Malicious file downloads
  - Provides visual infection demonstrations for other systems
  - Documents complete infection chain

### ❔ **Additional/Optional Scripts:**
- `recon_script.sh` - Comprehensive network reconnaissance
- `exploit_script.sh` - General web application exploitation

---

## 🚀 Execution Order

For best results, follow this execution order:

1. **First:** Set up monitoring on IDS
   ```bash
   ssh sensor-admin@192.168.56.11
   sudo tail -f /var/log/snort/snort.alert.fast
   ```

2. **Start with Keylogger Attack:**
   ```bash
   chmod +x keylogger_attack.sh
   ./keylogger_attack.sh
   ```

3. **Continue with Malware Deployment:**
   ```bash
   chmod +x malware_attack.sh
   ./malware_attack.sh
   ```

4. **Finish with DoS Attack:**
   ```bash
   chmod +x dos_script.sh
   ./dos_script.sh
   ```

5. **Optional additional attacks:**
   ```bash
   chmod +x recon_script.sh exploit_script.sh
   ./recon_script.sh
   ./exploit_script.sh
   ```

---

## 📊 Expected Results

### For Task 3 (Keylogger):
- Creation of keylogger files on victim server
- Captured data and system information
- IDS detection of suspicious file creation/command execution

### For Task 4 (DDoS):
- Server becoming unresponsive during attacks
- Elevated resource usage (CPU, memory, connections)
- IDS alerts for flooding patterns

### For Task 5 (Malware & Cross-infection):
- Malware files deployed on victim server
- Web-accessible infection vectors created
- Cross-system infection demonstration pages
- IDS detection of suspicious activity

---

## 📝 Documentation Tips

For each attack:
1. **Take screenshots** of:
   - Attack execution progress
   - IDS alerts showing detection
   - Evidence of successful attack
   - System impacts

2. **Record metrics:**
   - Detection rates
   - Attack success/failure
   - Server response times
   - IDS alert patterns

3. **Document everything** for your final report (Task 11)

---

## ⚠️ Important Notes

- All scripts include monitoring pauses to check IDS alerts
- These are educational demonstrations only
- Keep all activity within your lab environment
- Scripts provide cleanup options after completion

**Good luck with your ethical hacking lab!**

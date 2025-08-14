# Ethical Hacking Final Project - Lab Documentation

**Student:** [Your Name]  
**Date Started:** August 12, 2025  
**Date Completed:** [TBD]  

---

## Project Overview

This project demonstrates various cybersecurity concepts through controlled ethical hacking exercises using three virtual machines:
- **Victim-Server** (Ubuntu Server 22.04) - Target system
- **Sensor-IDS** (Ubuntu Server 22.04 + Snort) - Intrusion Detection System
- **Attacker-Kali** (Kali Linux) - Attack platform

---

## Network Configuration

### VM Network Setup
- **Network Type:** NAT + Host-Only Adapter
- **Host-Only Network:** 192.168.56.0/24
- **VM IP Addresses:**
  - Victim-Server: 192.168.56.10
  - Sensor-IDS: 192.168.56.11 (planned)
  - Attacker-Kali: 192.168.56.12 (planned)

**📸 RECOMMENDED SCREENSHOT:** VirtualBox network settings for all three VMs showing NAT + Host-Only configuration

---

## Task Progress and Documentation

### ✅ Task 1: Deploy Apache Web Server with No Security (10%)

**Date Completed:** August 13, 2025  
**Status:** COMPLETED  

#### What Was Done:
1. **VM Startup and Access**
   - Started Victim-Server VM using VirtualBox
   - Connected via SSH: `ssh victim-admin@192.168.56.10`
   - Credentials: victim-admin / victim123

2. **Apache Installation and Verification**
   - Apache2 was already installed from previous session
   - Verified service status: `sudo systemctl status apache2`
   - **Apache Version:** Apache/2.4.58 (Ubuntu)
   - **Service Status:** Active and running on startup

3. **PHP Installation and Configuration**
   - PHP 8.3.6 was already installed with libapache2-mod-php
   - Verified PHP integration with Apache

4. **Vulnerable Content Creation**
   - Created vulnerable PHP page: `/var/www/html/vulnerable.php`
   - **Vulnerabilities implemented:**
     - Cross-Site Scripting (XSS) via `$_GET['name']` parameter
     - Command Injection via `$_GET['cmd']` parameter
   - Tested command injection: `curl "http://localhost/vulnerable.php?cmd=whoami"`
   - **Result:** Successfully executed commands as www-data user

5. **Network Configuration Verification**
   - Confirmed network interfaces:
     - NAT (enp0s3): 10.0.2.15/24 - Internet access
     - Host-Only (enp0s8): 192.168.56.10/24 - Lab network
   - Web server accessible on both interfaces

#### Key Commands Used:
```bash
# Service management
sudo systemctl status apache2
apache2 -v

# Testing web server
curl http://localhost/vulnerable.php
curl "http://localhost/vulnerable.php?cmd=whoami"

# Network verification
ip addr show
```

#### Evidence and Testing:
- ✅ Apache serves default Ubuntu page
- ✅ PHP processing working correctly  
- ✅ Command injection vulnerability confirmed
- ✅ XSS vulnerability present
- ✅ Server accessible from lab network (192.168.56.10)

**📸 RECOMMENDED SCREENSHOTS:**
1. Apache status output showing active service
2. Vulnerable PHP page in browser showing server info
3. Command injection test showing successful execution
4. Network interface configuration (ip addr show output)

#### Security Weaknesses Intentionally Introduced:
- No input validation on PHP parameters
- Direct system() command execution
- No XSS protection
- Default Apache configuration (no hardening)
- PHP error reporting enabled

---

### ✅ Task 2: Install an IDS (Snort) - 10%
**Date Completed:** August 13, 2025  
**Status:** COMPLETED  
**Target VM:** Sensor-IDS (192.168.56.11)

#### What Was Accomplished:
1. **Snort Installation and Setup**
   - Successfully installed Snort IDS version 2.9.20 GRE (Build 82)
   - Configured network monitoring on interface enp0s8 (Host-Only network)
   - Set up proper logging directories with appropriate permissions

2. **Network Configuration**
   - **HOME_NET:** Configured to monitor 192.168.56.0/24 (our lab network)
   - **EXTERNAL_NET:** Set to !$HOME_NET (everything outside our network)
   - **Log Directory:** /var/log/snort (properly configured with snort:snort ownership)

3. **Custom Rules Implementation**
   Created custom detection rules in `/etc/snort/rules/local.rules`:
   - **Command Injection Detection** (SID: 1000001)
   - **XSS Attack Detection** (SID: 1000002)
   - **SQL Injection Detection** (SID: 1000003)
   - **DoS Attack Detection** (SID: 1000004)
   - **Vulnerable PHP File Access** (SID: 1000005)
   - **ICMP Ping Sweep Detection** (SID: 1000006)
   - **Port Scan Detection** (SID: 1000007)
   - **Curl User-Agent Detection** (SID: 1000008)

4. **Service Configuration**
   - Snort running as daemon with proper user/group privileges (snort:snort)
   - Monitoring enp0s8 interface (192.168.56.11)
   - Real-time packet inspection and logging enabled
   - Community rules loaded (comprehensive threat detection)

5. **Testing and Validation**
   - **Configuration Test:** ✅ Passed (`snort -T` successful)
   - **Network Connectivity:** ✅ Can reach Victim-Server (192.168.56.10)
   - **Basic Detection:** ✅ Detecting network scans (UPnP service discovery)
   - **Web Attack Testing:** ✅ Successfully accessed vulnerable.php with command injection

#### Key Commands Used:
```bash
# Installation
sudo apt install -y snort

# Configuration
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.backup
sudo sed -i 's/ipvar HOME_NET any/ipvar HOME_NET 192.168.56.0\/24/' /etc/snort/snort.conf
sudo sed -i 's/ipvar EXTERNAL_NET any/ipvar EXTERNAL_NET !$HOME_NET/' /etc/snort/snort.conf

# Setup logging
sudo mkdir -p /var/log/snort
sudo chown snort:snort /var/log/snort

# Start daemon
sudo snort -D -u snort -g snort -c /etc/snort/snort.conf -i enp0s8 -l /var/log/snort
```

#### Files Modified/Created:
- `/etc/snort/snort.conf` - Updated network configuration
- `/etc/snort/rules/local.rules` - Custom detection rules
- `/var/log/snort/` - Log directory for alerts and traffic logs

#### IDS Status: 🟢 **ACTIVE**
- Snort daemon running (3 processes active)
- Monitoring network traffic on 192.168.56.0/24
- Real-time threat detection enabled
- Logging all suspicious activities

**📸 RECOMMENDED SCREENSHOTS:**
1. Snort version output showing successful installation
2. Configuration test showing "successfully validated"
3. Process list showing Snort daemon running
4. Alert log showing detection of network activities
5. Custom rules file content
6. Network interface monitoring (enp0s8 configuration)

---

## 🔍 How to Monitor Alerts During Attacks

### **Real-time Alert Monitoring (Use This During Attacks)**

**SSH into Sensor-IDS VM:**
```bash
ssh sensor-admin@192.168.56.11
```

**Watch alerts in real-time:**
```bash
sudo tail -f /var/log/snort/snort.alert.fast
```

### **Alert Analysis Commands**
```bash
# View recent alerts
sudo tail -20 /var/log/snort/snort.alert.fast

# Count total alerts
sudo wc -l /var/log/snort/snort.alert.fast

# Search for specific attacks
sudo grep "Command Injection" /var/log/snort/snort.alert.fast
sudo grep "XSS Attack" /var/log/snort/snort.alert.fast
sudo grep "DoS Attack" /var/log/snort/snort.alert.fast

# Detailed packet information
sudo tail -f /var/log/snort/snort.alert
```

### **Recommended Workflow for Each Attack**
1. **Before Attack:** SSH to IDS and start `sudo tail -f /var/log/snort/snort.alert.fast`
2. **During Attack:** Watch alerts appear in real-time
3. **After Attack:** Press `Ctrl+C` and document/screenshot results

---

## Next Steps

### 🔄 Task 3: Perform a Keylogger Attack - 10%
**Status:** READY TO START  
**Target VM:** Attacker-Kali (192.168.56.12) → Victim-Server (192.168.56.10)

**Planned Actions:**
1. Set up Attacker-Kali VM (if not already done)
2. Install keylogger tools
3. Execute keylogger attack on Victim-Server
4. Monitor IDS detection
5. Document evidence and screenshots

---

## Notes and Observations

- All VMs successfully configured with dual network adapters
- Apache web server provides good attack surface with multiple vulnerabilities
- SSH access working properly for remote management
- Host-only network properly isolated for lab activities

---

## Evidence Collection

### Files Created:
- `/var/www/html/vulnerable.php` - Intentionally vulnerable web application

### Log Files to Monitor:
- `/var/log/apache2/access.log` - Web server access logs
- `/var/log/apache2/error.log` - Web server error logs
- `/var/log/auth.log` - Authentication attempts

### Testing Commands for Later Reference:
```bash
# Command injection tests
curl "http://192.168.56.10/vulnerable.php?cmd=ls"
curl "http://192.168.56.10/vulnerable.php?cmd=ps aux"
curl "http://192.168.56.10/vulnerable.php?cmd=netstat -tuln"

# XSS tests
curl "http://192.168.56.10/vulnerable.php?name=<script>alert('xss')</script>"
```

---

*This document will be updated after each task completion with detailed steps, screenshots, and evidence.*

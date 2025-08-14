# 🛡️ Server Hardening Implementation Summary

## Server Information
- **Hostname:** hardened-server
- **IP Address:** 192.168.56.13/24 (changed from 192.168.56.10)
- **Original Server:** victim-server (192.168.56.10)
- **Purpose:** Demonstrate security hardening effectiveness vs vulnerable server

## 🔧 Implemented Security Measures

### 1. Network Configuration
```bash
# Changed static IP to prevent conflicts
sudo netplan apply
# New IP: 192.168.56.13/24
# Interface: enp0s8
```

### 2. Firewall Configuration (UFW)
```bash
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw --force enable
```

**Status:** Active with restrictive rules
- Only SSH (22) and HTTP (80) allowed inbound
- All other ports blocked by default

### 3. Intrusion Prevention (Fail2ban)
```bash
sudo apt install -y fail2ban
```

**Configuration:** `/etc/fail2ban/jail.local`
```ini
[DEFAULT]
bantime = 3600      # 1 hour ban
maxretry = 5        # 5 attempts before ban
findtime = 600      # Check last 10 minutes

[sshd]
enabled = true
maxretry = 3        # SSH: 3 attempts = 2-hour ban
bantime = 7200

# Web protections
[apache-auth]       # Authentication attacks
[apache-badbots]    # Bad bot blocking  
[apache-noscript]   # Script injection
[apache-overflows]  # Buffer overflows
```

**Active Jails:** 5 jails monitoring SSH and Apache attacks

### 4. SSH Hardening
```bash
# /etc/ssh/sshd_config additions:
PermitRootLogin no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
X11Forwarding no
AllowUsers victim-admin
PermitEmptyPasswords no
```

### 5. Web Server Hardening (Apache)

#### A. ModSecurity Web Application Firewall
```bash
sudo apt install -y libapache2-mod-security2 modsecurity-crs
sudo cp /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf
```

#### B. Security Headers & Attack Prevention
**Configuration:** `/etc/apache2/conf-available/security-hardening.conf`

**Security Headers:**
```apache
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options SAMEORIGIN
Header always set X-XSS-Protection "1; mode=block"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
Header always set Content-Security-Policy "default-src 'self'"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
```

**Attack Pattern Blocking:**
- SQL Injection detection and blocking
- XSS (Cross-Site Scripting) prevention
- Directory traversal protection (`../` patterns blocked)
- Command injection prevention
- Buffer overflow protection
- Bad bot blocking
- File inclusion attack prevention

**Server Hardening:**
```apache
ServerTokens Prod           # Hide Apache version
ServerSignature Off         # Disable server signature
Timeout 60                  # Connection timeout
LimitRequestBody 10485760   # 10MB request limit
```

### 6. System Monitoring & Integrity

#### A. File Integrity Monitoring (AIDE)
```bash
sudo apt install -y aide
sudo aideinit    # Initialize baseline database
```

#### B. Rootkit Detection
```bash
sudo apt install -y chkrootkit rkhunter
```

**Automated Scans:** Daily cron jobs for integrity checks

## 🎯 Attack Mitigation Capabilities

### Protected Against:
1. **Brute Force Attacks**
   - SSH: 3 failed attempts = 2-hour IP ban
   - Web: 5 failed attempts = 1-hour IP ban

2. **Web Application Attacks**
   - SQL Injection → ModSecurity + custom regex patterns
   - Cross-Site Scripting (XSS) → Headers + input filtering
   - Directory Traversal → Rewrite rules block `../`
   - Command Injection → Pattern matching
   - File Inclusion → Path validation

3. **Network Attacks**
   - Port scanning → Firewall blocks unused ports
   - Service enumeration → Limited attack surface

4. **System Compromise**
   - Rootkits → Daily scanning with multiple tools
   - File modifications → AIDE integrity monitoring
   - Unauthorized access → SSH hardening + logging

## 📊 Expected Snort Detection Comparison

### Vulnerable Server (192.168.56.10)
- **Expected:** Snort alerts for successful attacks
- **Behavior:** Attacks penetrate and execute
- **Logs:** Show successful exploitation attempts

### Hardened Server (192.168.56.13) 
- **Expected:** Snort alerts for blocked/failed attacks
- **Behavior:** Attacks blocked at multiple layers
- **Logs:** Show failed attempts and IP bans

## 🔍 Verification Commands

### Check Services Status:
```bash
sudo systemctl status fail2ban
sudo systemctl status apache2
sudo systemctl status ssh
sudo ufw status
```

### Monitor Active Protection:
```bash
sudo fail2ban-client status
sudo fail2ban-client status sshd
sudo tail -f /var/log/fail2ban.log
sudo tail -f /var/log/apache2/error.log
```

### Test Security Headers:
```bash
curl -I http://192.168.56.13
```

## 📁 Configuration Files Created/Modified

1. `/etc/netplan/50-cloud-init.yaml` - Network configuration
2. `/etc/fail2ban/jail.local` - Intrusion prevention rules
3. `/etc/ssh/sshd_config` - SSH hardening settings
4. `/etc/apache2/conf-available/security-hardening.conf` - Web security
5. `/etc/modsecurity/modsecurity.conf` - WAF configuration

## 🚀 Next Steps

1. **Testing Phase:**
   - Run attacks against both servers
   - Monitor Snort detection differences
   - Verify protection effectiveness

2. **Analysis:**
   - Compare Snort logs between vulnerable vs hardened
   - Document attack success/failure rates
   - Generate security improvement metrics

## 📝 Implementation Date
**Date:** August 13, 2025  
**Implementation Time:** ~30 minutes  
**Status:** ✅ Complete and Active

---
*This hardened server demonstrates multiple layers of security defense that should significantly reduce successful attack vectors compared to the vulnerable baseline server.*

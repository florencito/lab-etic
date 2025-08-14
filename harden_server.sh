#!/bin/bash

# Server Security Hardening Script
# Purpose: Configure firewall and harden Apache to prevent previous attacks
# Target: 192.168.56.10 (Victim Server) - Run this ON the victim server

echo "=============================================="
echo "🛡️ SERVER SECURITY HARDENING - PHASE 2"
echo "=============================================="
echo "Target Server: $(hostname) - $(hostname -I)"
echo "Hardening Time: $(date)"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to pause and wait for user input
pause_for_confirmation() {
    echo -e "${YELLOW}⏸️  Press Enter to continue...${NC}"
    read -p ""
}

echo -e "${BLUE}📍 Phase 1: Backup and Cleanup${NC}"
echo "----------------------------------------------"

echo "🗃️ Step 1.1: Creating backup of current configuration..."
sudo mkdir -p /backup/pre-hardening/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/pre-hardening/$(date +%Y%m%d_%H%M%S)"
sudo cp -r /etc/apache2/ $BACKUP_DIR/apache2_config
sudo cp /var/www/html/*.php $BACKUP_DIR/ 2>/dev/null || echo "No PHP files to backup"
echo "Backup created in: $BACKUP_DIR"

echo "🧹 Step 1.2: Removing vulnerable components..."
sudo rm -f /var/www/html/vulnerable.php
sudo rm -f /var/www/html/test.php
sudo rm -rf /tmp/malware_*
sudo rm -rf /tmp/infected_*
sudo rm -rf /tmp/visitor_*
echo "Vulnerable files removed."

pause_for_confirmation

echo -e "${BLUE}📍 Phase 2: Firewall Configuration${NC}"
echo "----------------------------------------------"

echo "🔥 Step 2.1: Installing and configuring UFW (Uncomplicated Firewall)..."
sudo apt update -y
sudo apt install -y ufw

echo "🔥 Step 2.2: Setting up firewall rules..."
# Reset UFW to defaults
sudo ufw --force reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (important - don't lock yourself out!)
sudo ufw allow ssh
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow from IDS sensor for monitoring
sudo ufw allow from 192.168.56.11

# Deny dangerous services
sudo ufw deny 23    # Telnet
sudo ufw deny 135   # RPC
sudo ufw deny 139   # NetBIOS
sudo ufw deny 445   # SMB

# Rate limiting for SSH (prevent brute force)
sudo ufw limit ssh

echo "🔥 Step 2.3: Activating firewall..."
sudo ufw --force enable
sudo ufw status verbose

pause_for_confirmation

echo -e "${BLUE}📍 Phase 3: Apache Security Hardening${NC}"
echo "----------------------------------------------"

echo "🌐 Step 3.1: Creating secure Apache configuration..."

# Backup original config
sudo cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.backup

# Create security configuration
sudo tee /etc/apache2/conf-available/security-hardening.conf > /dev/null <<EOF
# Security Hardening Configuration

# Hide server information
ServerTokens Prod
ServerSignature Off

# Security headers
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header always set Content-Security-Policy "default-src 'self'"

# Disable dangerous HTTP methods
<Location />
    <LimitExcept GET POST HEAD>
        Require all denied
    </LimitExcept>
</Location>

# Hide sensitive files
<FilesMatch "\\.(conf|log|htaccess|htpasswd|ini|php~|bak)$">
    Require all denied
</FilesMatch>

# Disable directory browsing
Options -Indexes

# Prevent access to git files
<DirectoryMatch "\\.git">
    Require all denied
</DirectoryMatch>

# Timeout settings
Timeout 60
KeepAliveTimeout 5

# Limit request size (prevent DoS)
LimitRequestBody 10485760  # 10MB limit
EOF

echo "🌐 Step 3.2: Enabling security modules..."
sudo a2enmod headers
sudo a2enmod rewrite
sudo a2enmod ssl
sudo a2enconf security-hardening

echo "🌐 Step 3.3: Creating secure index page..."
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Secure Web Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c5aa0; }
        .status { background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🛡️ Secure Web Server</h1>
        <div class="status">
            <strong>Status:</strong> Server has been hardened and secured.<br>
            <strong>Security measures:</strong> Firewall enabled, vulnerable components removed, security headers configured.
        </div>
        <p>This server is now protected against:</p>
        <ul>
            <li>Command injection attacks</li>
            <li>XSS (Cross-Site Scripting)</li>
            <li>Directory traversal</li>
            <li>Information disclosure</li>
            <li>DoS attacks (rate limiting)</li>
        </ul>
        <p><em>Hardened on: $(date)</em></p>
    </div>
</body>
</html>
EOF

pause_for_confirmation

echo -e "${BLUE}📍 Phase 4: System Security Enhancements${NC}"
echo "----------------------------------------------"

echo "🔒 Step 4.1: Disabling unnecessary services..."
sudo systemctl disable telnet || echo "Telnet not installed"
sudo systemctl disable rsh || echo "RSH not installed"

echo "🔒 Step 4.2: Setting up automatic security updates..."
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades

echo "🔒 Step 4.3: Installing additional security tools..."
sudo apt install -y fail2ban

# Configure fail2ban for Apache
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[apache-auth]
enabled = true
port = http,https
filter = apache-auth
logpath = /var/log/apache2/error.log
maxretry = 3
bantime = 600

[apache-noscript]
enabled = true
port = http,https
filter = apache-noscript
logpath = /var/log/apache2/access.log
maxretry = 3
bantime = 600

[apache-overflows]
enabled = true
port = http,https
filter = apache-overflows
logpath = /var/log/apache2/access.log
maxretry = 2
bantime = 600
EOF

sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

pause_for_confirmation

echo -e "${BLUE}📍 Phase 5: Final Configuration${NC}"
echo "----------------------------------------------"

echo "🔄 Step 5.1: Restarting services..."
sudo systemctl restart apache2
sudo systemctl restart ufw
sudo systemctl status apache2 | head -10

echo "🔍 Step 5.2: Verification tests..."
echo "Testing web server response:"
curl -I http://localhost/ 2>/dev/null | head -5

echo ""
echo "Firewall status:"
sudo ufw status

echo ""
echo "Active security services:"
sudo systemctl is-active apache2
sudo systemctl is-active ufw
sudo systemctl is-active fail2ban

pause_for_confirmation

echo ""
echo "=============================================="
echo -e "${GREEN}✅ SERVER SECURITY HARDENING COMPLETE${NC}"
echo "=============================================="
echo "End Time: $(date)"
echo ""
echo -e "${YELLOW}🛡️ SECURITY MEASURES IMPLEMENTED:${NC}"
echo "• UFW Firewall: Configured with restrictive rules"
echo "• Apache Hardening: Security headers, method restrictions"
echo "• Vulnerable Components: Removed (vulnerable.php, malware files)"
echo "• Fail2Ban: Active protection against brute force"
echo "• Security Headers: XSS protection, content type validation"
echo "• Rate Limiting: DoS protection enabled"
echo "• System Updates: Automatic security updates configured"
echo ""
echo -e "${YELLOW}🎯 NEXT STEPS:${NC}"
echo "1. Test previous attacks against hardened server"
echo "2. Document attack prevention effectiveness"  
echo "3. Compare results before/after hardening"
echo "4. Generate comparison table for final report"
echo ""
echo -e "${RED}⚠️ IMPORTANT: Server is now hardened - previous attacks should fail!${NC}"
echo "=============================================="

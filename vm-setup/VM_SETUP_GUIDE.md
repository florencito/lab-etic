# Virtual Machine Setup Guide

🖥️ **Complete VM configuration for the ethical hacking lab**

## Required Virtual Machines

### 1. Victim-Server (Ubuntu Server 22.04)
**Role**: Target system with vulnerable services
**IP Address**: 192.168.56.10

#### System Requirements:
- **RAM**: 2GB minimum
- **Disk**: 20GB
- **Network**: NAT + Host-Only Adapter
- **OS**: Ubuntu Server 22.04 LTS

#### Post-Installation Setup:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Apache and PHP
sudo apt install apache2 php libapache2-mod-php -y

# Enable Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Configure network interfaces
sudo netplan apply
```

#### Required Services:
- Apache2 web server
- PHP 8.x
- SSH server
- Intentionally vulnerable web applications

### 2. Sensor-IDS (Ubuntu Server 22.04 + Snort)
**Role**: Intrusion Detection System monitoring
**IP Address**: 192.168.56.11

#### System Requirements:
- **RAM**: 2GB minimum  
- **Disk**: 20GB
- **Network**: NAT + Host-Only Adapter
- **OS**: Ubuntu Server 22.04 LTS

#### IDS Configuration:
```bash
# Install Snort IDS
sudo apt install snort -y

# Configure for network monitoring
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.backup

# Update network settings
sudo sed -i 's/ipvar HOME_NET any/ipvar HOME_NET 192.168.56.0\/24/' /etc/snort/snort.conf
sudo sed -i 's/ipvar EXTERNAL_NET any/ipvar EXTERNAL_NET !$HOME_NET/' /etc/snort/snort.conf

# Setup logging directory
sudo mkdir -p /var/log/snort
sudo chown snort:snort /var/log/snort
```

#### Required Services:
- Snort IDS v2.9.20+
- SSH server
- Network packet capture
- Custom detection rules

### 3. Attacker-Kali (Kali Linux)
**Role**: Penetration testing platform
**IP Address**: 192.168.56.12

#### System Requirements:
- **RAM**: 4GB minimum
- **Disk**: 25GB
- **Network**: NAT + Host-Only Adapter
- **OS**: Kali Linux (latest)

#### Tools Configuration:
```bash
# Update Kali repositories
sudo apt update && sudo apt upgrade -y

# Install additional tools
sudo apt install metasploit-framework -y
sudo apt install nmap wireshark -y

# Enable SSH (if needed)
sudo systemctl enable ssh
sudo systemctl start ssh
```

#### Required Tools:
- Metasploit Framework
- Nmap network scanner
- Wireshark packet analyzer
- Custom attack scripts

## Network Configuration

### VirtualBox Host-Only Network
**Network Range**: 192.168.56.0/24  
**DHCP**: Disabled (using static IPs)

#### Network Adapter Configuration:
```
Adapter 1: NAT (for internet access)
Adapter 2: Host-Only Adapter (vboxnet0)
```

### Static IP Configuration

#### Ubuntu VMs (/etc/netplan/00-installer-config.yaml):
```yaml
network:
  ethernets:
    enp0s3:  # NAT adapter
      dhcp4: true
    enp0s8:  # Host-Only adapter
      dhcp4: no
      addresses: [192.168.56.XX/24]  # Replace XX with 10, 11, or 12
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
  version: 2
```

#### Apply configuration:
```bash
sudo netplan apply
```

## Security Considerations

### Isolation Requirements:
- Host-Only network isolated from production
- No external network access from attack tools
- Complete containment of attack scenarios

### Access Control:
- SSH keys for secure remote access
- Firewall rules for controlled communication
- Regular snapshot creation for recovery

### Monitoring Setup:
- IDS monitoring all network traffic
- Log centralization for analysis
- Real-time alert configuration

## Setup Verification

### Network Connectivity Test:
```bash
# From any VM, test connectivity
ping 192.168.56.10  # Victim-Server
ping 192.168.56.11  # Sensor-IDS  
ping 192.168.56.12  # Attacker-Kali

# Verify web server
curl http://192.168.56.10
```

### Service Verification:
```bash
# Check Apache on Victim-Server
sudo systemctl status apache2

# Check Snort on Sensor-IDS
sudo systemctl status snort

# Check SSH on all VMs
sudo systemctl status ssh
```

## Troubleshooting

### Common Issues:

#### Network Problems:
- Verify Host-Only adapter enabled
- Check static IP configuration
- Confirm VirtualBox network settings

#### Service Issues:
- Verify service status with systemctl
- Check log files for errors
- Ensure proper permissions

#### Performance Problems:
- Allocate sufficient RAM
- Enable VM acceleration
- Use SSD storage when possible

---

*This guide ensures proper lab environment setup for controlled ethical hacking exercises.*

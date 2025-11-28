# Azure Cloud Networking: Hub and Spoke Topology Lab

Hey! In this lab, I utilized Microsoft Azure to create my own Hub and Spoke Topology. This was my first project ever! This lab helped me learn many critical skills and fundamentals within Azure including services Azure offers, how to deploy VNets, VMs, create Subnets, IP addressing, Network Security Groups (NSGs), and networking fundamentals!

## Table of Contents

- [Overview](#overview)
- [Architecture Diagram](#architecture-diagram)
- [What I Learned](#what-i-learned)
- [Azure Services Used](#azure-services-used)
- [Network Configuration](#network-configuration)
- [Testing Connectivity](#testing-connectivity)
- [Ping Commands and Scripts](#ping-commands-and-scripts)

## Overview

The Hub and Spoke topology is a networking model where a central "Hub" Virtual Network (VNet) acts as the central point of connectivity for multiple "Spoke" VNets. This architecture is commonly used in enterprise environments to:

- Centralize shared services (DNS, firewalls, domain controllers)
- Reduce costs by avoiding direct connections between all networks
- Simplify network management and security policies
- Enable better traffic inspection and control

## Architecture Diagram

```
                    ┌─────────────────────────────────────────────────────────────────┐
                    │                        AZURE CLOUD                              │
                    │                                                                 │
                    │     ┌──────────────────┐         ┌──────────────────┐          │
                    │     │   SPOKE 1 VNet   │         │   SPOKE 2 VNet   │          │
                    │     │   10.1.0.0/16    │         │   10.2.0.0/16    │          │
                    │     │                  │         │                  │          │
                    │     │  ┌────────────┐  │         │  ┌────────────┐  │          │
                    │     │  │    VM1     │  │         │  │    VM2     │  │          │
                    │     │  │ 10.1.1.4   │  │         │  │ 10.2.1.4   │  │          │
                    │     │  └────────────┘  │         │  └────────────┘  │          │
                    │     │                  │         │                  │          │
                    │     └────────┬─────────┘         └────────┬─────────┘          │
                    │              │                            │                    │
                    │              │    VNet Peering            │   VNet Peering     │
                    │              │                            │                    │
                    │              ▼                            ▼                    │
                    │     ┌────────────────────────────────────────────────┐         │
                    │     │                  HUB VNet                      │         │
                    │     │                 10.0.0.0/16                    │         │
                    │     │                                                │         │
                    │     │  ┌─────────────┐     ┌─────────────────────┐  │         │
                    │     │  │   Hub VM    │     │  Network Security   │  │         │
                    │     │  │  10.0.1.4   │     │    Group (NSG)      │  │         │
                    │     │  └─────────────┘     └─────────────────────┘  │         │
                    │     │                                                │         │
                    │     └────────────────────────────────────────────────┘         │
                    │                                                                 │
                    └─────────────────────────────────────────────────────────────────┘
```

## What I Learned

Throughout this project, I gained hands-on experience with several key Azure and networking concepts:

### Azure Fundamentals
- **Resource Groups**: How to organize and manage related Azure resources
- **Subscriptions**: Understanding Azure billing and resource management structure
- **Azure Portal Navigation**: Efficiently navigating the Azure management interface

### Virtual Networks (VNets)
- Creating and configuring VNets with proper address spaces
- Understanding CIDR notation and IP address planning
- Avoiding overlapping address spaces between peered VNets

### VNet Peering
- Establishing connections between VNets for cross-network communication
- Configuring peering settings (allow forwarded traffic, allow gateway transit)
- Understanding that peering is non-transitive (Spoke-to-Spoke requires going through Hub)

### Virtual Machines (VMs)
- Deploying Windows and/or Linux VMs
- Configuring VM sizes based on workload requirements
- Managing VM authentication (SSH keys, passwords)

### Subnets
- Dividing VNets into smaller, logical segments
- Reserving IP addresses for Azure services (first 4 and last 1 in each subnet)
- Planning subnet sizes for future growth

### Network Security Groups (NSGs)
- Creating inbound and outbound security rules
- Understanding rule priorities (lower number = higher priority)
- Allowing/denying specific traffic (ICMP for ping, SSH, RDP, etc.)
- Applying NSGs to subnets or individual network interfaces

### Networking Fundamentals
- TCP/IP basics and how they apply in cloud environments
- Understanding public vs. private IP addresses
- Troubleshooting network connectivity issues

## Azure Services Used

| Service | Purpose |
|---------|---------|
| **Virtual Networks (VNets)** | Isolated network environments in Azure |
| **Virtual Machines (VMs)** | Compute resources for testing connectivity |
| **VNet Peering** | Connecting VNets for cross-network communication |
| **Network Security Groups (NSGs)** | Firewall rules for traffic filtering |
| **Subnets** | Logical divisions within VNets |
| **Public IP Addresses** | External access to VMs |
| **Network Interfaces (NICs)** | Virtual network adapters for VMs |

## Network Configuration

### Address Space Planning

| Network | Address Space | Purpose |
|---------|---------------|---------|
| Hub VNet | 10.0.0.0/16 | Central hub for shared services |
| Spoke 1 VNet | 10.1.0.0/16 | Workload VNet 1 |
| Spoke 2 VNet | 10.2.0.0/16 | Workload VNet 2 |

### Subnet Configuration

| VNet | Subnet Name | Address Range | Notes |
|------|-------------|---------------|-------|
| Hub | default | 10.0.1.0/24 | Hub VM subnet |
| Spoke 1 | default | 10.1.1.0/24 | Spoke 1 VM subnet |
| Spoke 2 | default | 10.2.1.0/24 | Spoke 2 VM subnet |

## Testing Connectivity

### Prerequisites
1. VNet Peering must be established between Hub and each Spoke
2. NSG rules must allow ICMP traffic (for ping)
3. Windows Firewall (if applicable) must allow ICMP

### NSG Rule for Allowing Ping (ICMP)

To allow ping between VMs, create an inbound security rule:

| Property | Value |
|----------|-------|
| Source | Any (or specific IP range) |
| Source port ranges | * |
| Destination | Any |
| Destination port ranges | * |
| Protocol | ICMP |
| Action | Allow |
| Priority | 100 (or any number lower than deny rules) |
| Name | Allow-ICMP-Inbound |

## Ping Commands and Scripts

### Basic Ping Commands

#### Windows PowerShell

```powershell
# Ping a specific VM by private IP
ping 10.0.1.4

# Continuous ping (useful for testing during configuration changes)
ping 10.0.1.4 -t

# Ping with specific count
ping 10.0.1.4 -n 10

# Ping with larger packet size
ping 10.0.1.4 -l 1000

# Test connectivity to all VMs
ping 10.0.1.4   # Hub VM
ping 10.1.1.4   # Spoke 1 VM
ping 10.2.1.4   # Spoke 2 VM
```

#### Linux (Bash)

```bash
# Ping a specific VM by private IP
ping 10.0.1.4

# Ping with specific count
ping -c 10 10.0.1.4

# Continuous ping
ping 10.0.1.4

# Ping with specific packet size
ping -s 1000 10.0.1.4
```

### Connectivity Test Scripts

Ready-to-use scripts are available in the `scripts/` folder:

| Script | Platform | Description |
|--------|----------|-------------|
| [test-connectivity.ps1](scripts/test-connectivity.ps1) | Windows (PowerShell) | Tests connectivity to all VMs |
| [test-connectivity.sh](scripts/test-connectivity.sh) | Linux (Bash) | Tests connectivity to all VMs |

#### Usage

**Windows (PowerShell):**
```powershell
# Download and run
.\scripts\test-connectivity.ps1
```

**Linux (Bash):**
```bash
# Make executable and run
chmod +x scripts/test-connectivity.sh
./scripts/test-connectivity.sh
```

> **Note:** Edit the IP addresses in the scripts to match your actual VM configurations.

### Troubleshooting Tips

If pings are failing, check the following:

1. **VNet Peering Status**: Ensure peering is "Connected" on both sides
2. **NSG Rules**: Verify ICMP is allowed in inbound rules
3. **Windows Firewall**: On Windows VMs, ensure the firewall allows ICMP
4. **Route Tables**: Check if any custom route tables are affecting traffic
5. **VM Status**: Ensure the target VM is running

```powershell
# Check if ICMP is allowed through Windows Firewall
Get-NetFirewallRule -DisplayName "*ICMP*" | Select-Object DisplayName, Enabled, Direction, Action
```

---

## Resources

- [Azure Virtual Network Documentation](https://learn.microsoft.com/azure/virtual-network/)
- [Hub-spoke network topology in Azure](https://learn.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke)
- [VNet Peering](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview)
- [Network Security Groups](https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview)

---

*This project was created as part of my journey learning Azure cloud networking fundamentals.*

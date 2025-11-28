# Azure Cloud Networking: Hub and Spoke Topology Lab

Hey! In this lab, I built my own Hub and Spoke network in Microsoft Azure. This was my first project ever! This lab helped me learn so many important skills about Azure and networking. I learned how to create virtual networks, set up virtual machines, work with IP addresses, and control network traffic with security rules.

## Table of Contents

- [What is Hub and Spoke?](#what-is-hub-and-spoke)
- [My Network Diagram](#my-network-diagram)
- [What I Learned](#what-i-learned)
- [Azure Services I Used](#azure-services-i-used)
- [My Network Setup](#my-network-setup)
- [How to Test if VMs Can Talk to Each Other](#how-to-test-if-vms-can-talk-to-each-other)
- [Ping Commands I Used](#ping-commands-i-used)
- [Helpful Resources](#helpful-resources)

## What is Hub and Spoke?

Think of Hub and Spoke like an airport system:

- **The Hub** = The main airport (like Atlanta or Chicago O'Hare) where all flights connect
- **The Spokes** = Smaller regional airports that all connect to the main hub

In Azure networking:
- **The Hub VNet** = The central network that connects to everything
- **The Spoke VNets** = Separate networks that connect through the hub

### Why Use Hub and Spoke?

Imagine you have 3 separate offices (networks). Without a hub, you'd need to connect each office directly to every other office - that's a lot of connections to manage! With a hub, each office just connects to one central point.

**Benefits:**
- 🎯 **One central place** to put shared stuff (like firewalls and security tools)
- 💰 **Saves money** because you don't need as many connections
- 🔒 **Easier security** because all traffic goes through one place
- 📊 **Easier to manage** because there's less complexity

## My Network Diagram

Here's what my network looks like. The arrows show how the networks connect to each other:

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
                    │              │    (Connection)            │   (Connection)     │
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

**What the numbers mean:**
- `10.0.0.0/16` = This is the IP address range for the Hub network (over 65,000 addresses!)
- `10.1.0.0/16` = IP address range for Spoke 1
- `10.2.0.0/16` = IP address range for Spoke 2
- `10.0.1.4`, `10.1.1.4`, `10.2.1.4` = The specific IP addresses of each virtual machine

## What I Learned

Here's everything I learned while building this project:

### Azure Basics

- **Resource Groups** = Like folders on your computer - they help you organize your Azure stuff together
- **Subscriptions** = Your Azure account that tracks what you use and how much it costs
- **Azure Portal** = The website where you create and manage everything in Azure (portal.azure.com)

### Virtual Networks (VNets)

A VNet is like your own private network in the cloud. Think of it like your home WiFi network, but in Azure!

- I learned how to create VNets and give them IP address ranges
- **Important:** Each VNet needs its own unique IP range - they can't overlap!
- Example: Hub uses 10.0.x.x, Spoke 1 uses 10.1.x.x, Spoke 2 uses 10.2.x.x

### VNet Peering

Peering is how you connect two VNets together so they can talk to each other.

- Without peering, VNets are completely isolated (like two separate WiFi networks)
- **Key thing I learned:** Peering is NOT automatic between spokes! If Spoke 1 wants to talk to Spoke 2, the traffic has to go through the Hub first

### Virtual Machines (VMs)

A VM is basically a computer running in the cloud!

- I created Windows VMs to test my network
- Each VM gets its own IP address inside the VNet
- You connect to Windows VMs using Remote Desktop (RDP)

### Subnets

Subnets are smaller sections inside a VNet. Think of it like dividing a building into different floors.

- You can put different VMs on different subnets for organization
- **Good to know:** Azure reserves 5 IP addresses in every subnet (first 4 and last 1) for its own use

### Network Security Groups (NSGs)

NSGs are like a firewall - they control what traffic is allowed in and out.

- **Inbound rules** = Control what can come INTO your VM
- **Outbound rules** = Control what can go OUT of your VM
- **Priority numbers** = Lower numbers are checked first (100 beats 200)
- I had to create a rule to allow "ping" (ICMP) so I could test connectivity

### Networking Basics

- **Private IP** = The IP address inside your network (like 10.0.1.4) - only works inside Azure
- **Public IP** = The IP address that lets you connect from the internet
- **Ping** = A simple command to test if two computers can talk to each other

## Azure Services I Used

Here are all the Azure services I used in this project:

| Service | What Is It? |
|---------|-------------|
| **Virtual Networks (VNets)** | Your own private network in Azure - like having your own section of the internet |
| **Virtual Machines (VMs)** | Computers running in the cloud that you can connect to remotely |
| **VNet Peering** | The connection between two VNets that lets them communicate |
| **Network Security Groups (NSGs)** | Firewall rules that control what traffic is allowed |
| **Subnets** | Smaller sections inside a VNet to organize your resources |
| **Public IP Addresses** | Addresses that let you connect to your VMs from the internet |
| **Network Interfaces (NICs)** | The virtual "network card" that connects a VM to the network |

## My Network Setup

### IP Addresses I Used

Each network needs its own range of IP addresses. Here's what I set up:

| Network | IP Address Range | What It's For |
|---------|------------------|---------------|
| Hub VNet | 10.0.0.0/16 | The central hub that connects everything |
| Spoke 1 VNet | 10.1.0.0/16 | First spoke network |
| Spoke 2 VNet | 10.2.0.0/16 | Second spoke network |

> **Tip:** The `/16` is called CIDR notation. It tells you how big the network is - smaller numbers mean more IP addresses. A `/16` gives you over 65,000 addresses!

### Where I Put My VMs (Subnets)

| VNet | Subnet Name | IP Range | What's Inside |
|------|-------------|----------|---------------|
| Hub | default | 10.0.1.0/24 | Hub VM lives here |
| Spoke 1 | default | 10.1.1.0/24 | Spoke 1 VM lives here |
| Spoke 2 | default | 10.2.1.0/24 | Spoke 2 VM lives here |

## How to Test if VMs Can Talk to Each Other

### Before You Can Ping...

You need to set up a few things first:

1. ✅ **Create VNet Peering** - Connect the Hub to each Spoke in Azure Portal
2. ✅ **Allow Ping in NSG** - Create a security rule that allows ICMP (ping uses this)
3. ✅ **Allow Ping in Windows Firewall** - Windows blocks ping by default!

### Setting Up the NSG Rule to Allow Ping

In Azure Portal, go to your NSG and add this inbound rule:

| Setting | What to Enter |
|---------|---------------|
| Source | Any |
| Source port ranges | * (means "all") |
| Destination | Any |
| Destination port ranges | * |
| Protocol | ICMP |
| Action | Allow |
| Priority | 100 |
| Name | Allow-Ping |

> **What is ICMP?** It's the protocol that "ping" uses. If you don't allow ICMP, ping won't work even if your VMs are connected!

## Ping Commands I Used

### Basic Ping Commands

Open **Command Prompt** or **PowerShell** on your VM and try these:

```powershell
# Basic ping - sends 4 packets and shows if it worked
ping 10.0.1.4

# Keep pinging forever (good for testing while you make changes)
# Press Ctrl+C to stop
ping 10.0.1.4 -t

# Ping exactly 10 times
ping 10.0.1.4 -n 10

# Test all my VMs at once
ping 10.0.1.4   # This pings the Hub VM
ping 10.1.1.4   # This pings Spoke 1 VM
ping 10.2.1.4   # This pings Spoke 2 VM
```

### What Good Output Looks Like

When ping works, you'll see something like:
```
Reply from 10.0.1.4: bytes=32 time=1ms TTL=128
```

When ping fails, you'll see:
```
Request timed out.
```

### My Connectivity Test Script

I created a PowerShell script that tests all VMs at once! It's in the `scripts/` folder:

| Script | What It Does |
|--------|--------------|
| [test-connectivity.ps1](scripts/test-connectivity.ps1) | Pings all VMs and tells you which ones are reachable |

#### How to Run It

```powershell
# Run this in PowerShell
.\scripts\test-connectivity.ps1
```

> **Note:** You might need to edit the IP addresses in the script to match your VMs!

### Troubleshooting: Ping Not Working?

If your pings are failing, check these things one by one:

| Problem | How to Check | How to Fix |
|---------|--------------|------------|
| VNet Peering not connected | Go to VNet → Peerings → Check status | Should say "Connected" on both sides |
| NSG blocking ping | Check your NSG inbound rules | Add an "Allow ICMP" rule (see above) |
| Windows Firewall blocking | Run the command below | Enable the firewall rule for ICMP |
| VM is turned off | Check VM status in Azure Portal | Start the VM |

**Check Windows Firewall settings:**
```powershell
# This shows if ICMP (ping) is allowed through Windows Firewall
Get-NetFirewallRule -DisplayName "*ICMP*" | Select-Object DisplayName, Enabled, Direction, Action
```

---

## Helpful Resources

Want to learn more? Check out these Microsoft docs:

- 📖 [What is a Virtual Network?](https://learn.microsoft.com/azure/virtual-network/) - Learn the basics of VNets
- 🏗️ [Hub and Spoke Explained](https://learn.microsoft.com/azure/architecture/reference-architectures/hybrid-networking/hub-spoke) - Deep dive into this architecture
- 🔗 [VNet Peering Guide](https://learn.microsoft.com/azure/virtual-network/virtual-network-peering-overview) - How to connect VNets
- 🔒 [Network Security Groups](https://learn.microsoft.com/azure/virtual-network/network-security-groups-overview) - Understanding NSG rules

---

*This was my first Azure project! I'm a beginner learning cloud networking, and I hope this helps other beginners too! 🚀*

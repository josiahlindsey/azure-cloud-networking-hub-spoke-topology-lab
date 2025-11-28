#!/bin/bash
# test-connectivity.sh
# Script to test connectivity across Hub and Spoke topology
# Usage: ./test-connectivity.sh

# Define VMs and their IP addresses
# Modify these values to match your environment
declare -A VMS
VMS["Hub-VM"]="10.0.1.4"
VMS["Spoke1-VM"]="10.1.1.4"
VMS["Spoke2-VM"]="10.2.1.4"

echo "========================================"
echo "  Hub and Spoke Connectivity Test"
echo "========================================"
echo ""

success_count=0
fail_count=0

for vm in "${!VMS[@]}"; do
    ip="${VMS[$vm]}"
    echo "Testing connectivity to $vm ($ip)..."
    
    if ping -c 4 "$ip" > /dev/null 2>&1; then
        echo "  [SUCCESS] $vm is reachable"
        ((success_count++))
    else
        echo "  [FAILED] $vm is NOT reachable"
        ((fail_count++))
    fi
    echo ""
done

echo "========================================"
echo "  Test Complete"
echo "  Successful: $success_count | Failed: $fail_count"
echo "========================================"

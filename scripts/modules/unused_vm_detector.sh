#!/bin/bash

# -------------------------
# 🔍 unused_vm_detector.sh
# Scans Azure for:
#   1. Stopped (deallocated) VMs
#   2. Unused public IPs
#   3. Orphaned managed disks
# Saves the results in a timestamped report
# -------------------------

# Set timestamp for report
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
report_file="../../reports/unused_vm_resources_report_$timestamp.txt"
mkdir -p "$(dirname "$report_file")"

# Azure CLI login check
if ! az account show > /dev/null 2>&1; then
    echo "❌ Not logged into Azure. Please run 'az login'." | tee "$report_file"
    exit 1
fi

echo "🧼 Cloud Hygiene Scan Report - $timestamp" | tee "$report_file"
echo "=========================================" | tee -a "$report_file"

# -------------------------
# 1️⃣ Detect Stopped VMs
# -------------------------
echo -e "\n🔎 Stopped Virtual Machines:" | tee -a "$report_file"

az vm list -d --query "[?powerState=='VM deallocated'].[name, resourceGroup, location]" -o table |
tee -a "$report_file"

# -------------------------
# 2️⃣ Detect Unused Public IPs
# -------------------------
echo -e "\n🌐 Unused Public IPs:" | tee -a "$report_file"

az network public-ip list --query "[?ipConfiguration==null].[name, resourceGroup, ipAddress]" -o table |
tee -a "$report_file"

# -------------------------
# 3️⃣ Detect Orphaned Disks
# -------------------------
echo -e "\n💾 Orphaned Managed Disks (not attached to any VM):" | tee -a "$report_file"

az disk list --query "[?managedBy==null].[name, resourceGroup, location]" -o table |
tee -a "$report_file"

# -------------------------
# ✅ Completion Message
# -------------------------
echo -e "\n✅ Scan Complete.  Report saved to: $report_file"

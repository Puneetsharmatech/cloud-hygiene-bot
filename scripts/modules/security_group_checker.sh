#!/bin/bash

# ----------------------------
# 🔐 security_group_checker.sh
# Checks Azure NSGs for:
#   - Open ports to 0.0.0.0/0 (public access)
#   - Especially SSH (22), RDP (3389), HTTP (80), HTTPS (443)
# Saves report with timestamp
# ----------------------------

# Timestamp for filename
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
report_file="../../reports/nsg_security_report_$timestamp.txt"

# Azure login check
if ! az account show > /dev/null 2>&1; then
    echo "❌ Not logged into Azure. Please run 'az login'." | tee "$report_file"
    exit 1
fi

echo "🔐 NSG Security Scan - $timestamp" | tee "$report_file"
echo "====================================" | tee -a "$report_file"

# Get all NSGs
nsgs=$(az network nsg list --query "[].{name:name, rg:resourceGroup}" -o json)

# Loop through each NSG
echo "$nsgs" | jq -c '.[]' | while read -r nsg; do
    name=$(echo "$nsg" | jq -r '.name')
    rg=$(echo "$nsg" | jq -r '.rg')

    echo -e "\n📦 NSG: $name (RG: $rg)" | tee -a "$report_file"

    # Get all security rules for this NSG
    rules=$(az network nsg rule list --nsg-name "$name" --resource-group "$rg" -o json)

    echo "$rules" | jq -c '.[]' | while read -r rule; do
        access=$(echo "$rule" | jq -r '.access')
        direction=$(echo "$rule" | jq -r '.direction')
        dest_port=$(echo "$rule" | jq -r '.destinationPortRange')
        src_prefix=$(echo "$rule" | jq -r '.sourceAddressPrefix')
        name_rule=$(echo "$rule" | jq -r '.name')

        # If public access is allowed
        if [[ "$access" == "Allow" && "$direction" == "Inbound" && "$src_prefix" == "0.0.0.0/0" ]]; then
            echo "⚠️  Rule '$name_rule' allows $dest_port from ANY IP (0.0.0.0/0)" | tee -a "$report_file"
        fi
    done
done

echo -e "\n✅ NSG Scan complete. Report saved to $report_file"

#!/bin/bash

# ----------------------------------
# 🔁 run_all.sh
# Master script that runs all hygiene modules:
#   - Unused resource scanner
#   - NSG security rule checker
# Logs start and end time, and module output
# ----------------------------------

# Timestamp for this run
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
logfile="../reports/full_scan_log_$timestamp.txt"
mkdir -p "$(dirname "$logfile")"

# Start log
echo "🧼 Cloud Hygiene Bot - Full Run ($timestamp)" | tee "$logfile"
echo "==============================================" | tee -a "$logfile"

start_time=$(date +%s)

# Run unused VM detector
echo -e "\n▶️ Running unused_vm_detector.sh..." | tee -a "$logfile"
(cd modules && ./unused_vm_detector.sh) >> "$logfile" 2>&1

# Run security group checker
echo -e "\n▶️ Running security_group_checker.sh..." | tee -a "$logfile"
(cd modules && ./security_group_checker.sh) >> "$logfile" 2>&1

end_time=$(date +%s)
elapsed=$((end_time - start_time))

# End summary
echo -e "\n✅ Full hygiene scan complete in $elapsed seconds." | tee -a "$logfile"
echo "📄 Log saved to: $logfile"

# ✅ Copy dynamic log to static name for GitHub Actions to upload
cp "$logfile" "../reports/latest_full_scan_log.txt"

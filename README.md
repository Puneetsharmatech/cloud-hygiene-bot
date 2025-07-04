# ☁️ Cloud Hygiene Bot

A modular, automated tool that scans your Azure infrastructure for:
- 🧼 Unused resources (e.g., stopped VMs, orphan disks)
- 🧭 Terraform drift
- 🔐 Basic security issues (e.g., public IPs, open ports)

## 🚀 Tech Stack

- Bash (scripting)
- Terraform (IaC)
- Azure CLI
- Ubuntu 22.04 LTS
- (Later: GitHub Actions, Slack/Email alerts, Python for reports)

## 📁 Project Structure

cloud-hygiene-bot/
├── terraform/ # Infrastructure (Azure VM, etc.)
│ └── azure_vm/
├── scripts/ # Bash scripts for checks
├── reports/ # Generated scan reports
├── logs/ # System logs
└── README.md


## 🔧 How to Use

1. Clone the repo
2. `cd terraform/azure_vm/`
3. Run:
   ```bash
   terraform init
   terraform apply


---

## ✅  Initialize and Push Code

```bash
cd cloud-hygiene-bot
git add .
git commit -m "Initial Terraform code and README setup"
git push origin main

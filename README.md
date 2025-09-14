# 🧼 Cloud Hygiene Bot: Keeping Azure Tidy

Every cloud environment needs a little maintenance. The **Cloud Hygiene Bot** is my solution to a common problem: preventing cloud sprawl, managing costs, and staying secure. It's a hands-on project that demonstrates how to build a scalable, automated tool for cloud infrastructure management.

### The Problem It Solves

As cloud environments grow, it's easy to lose track of resources. This bot tackles key "cloud hygiene" issues:

* **Unused Resources:** Ever left a VM running or a disk unattached? This bot finds them, saving you money.
* **Security Gaps:** It performs quick checks for basic security risks, like public IPs on sensitive services.

### 🛠️ The Tech Behind the Bot

This project was a great way to put key DevOps tools into practice. Here's a look under the hood:

* **Core Automation:** The heart of the bot is **Bash**, scripting the logic to execute scans and generate reports.
* **Infrastructure as Code:** **Terraform** provisions the Azure VM that hosts the bot, showcasing a full IaC workflow.
* **Interfacing with Azure:** **Azure CLI** is used for all communication and data retrieval from the cloud environment.
* **Foundation:** Built on **Ubuntu 22.04 LTS**, a reliable and widely used operating system.
* **Scalable Architecture:** This modular design is ready for future integration with **GitHub Actions** for automated CI/CD and **Python** for more advanced reporting.

### How It Works

The structure is simple and logical, built for both clarity and functionality:

* `terraform/`: This folder contains the Terraform configuration files to spin up the entire infrastructure needed to run the bot.
* `scripts/`: All the Bash scripts that perform the actual "hygiene" checks are here. They can be run independently or as a sequence.
* `reports/` & `logs/`: The bot places all its findings and operational logs here, providing a clear record of its work.

### Ready to Run?

1.  Start by cloning the repo: `git clone <repository-url>`
2.  Go into the Terraform directory: `cd terraform/azure_vm/`
3.  Provision the infrastructure with Terraform:
    ```bash
    terraform init
    terraform apply
    ```
    Once applied, the infrastructure is ready for the hygiene checks to begin!



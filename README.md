# AWS 3-Tier Production Architecture (Terraform)

## 📌 Overview

This project implements a **production-grade 3-tier architecture on AWS** using Terraform.

The infrastructure is designed following cloud best practices:

- Multi-AZ deployment
- Public and Private subnets
- Application Load Balancer
- Auto Scaling Group
- Private EC2 instances
- RDS database (Multi-AZ)
- Secure Security Group design
- High Availability & Fault Tolerance

---

## 🏗 Architecture

### Services Used

- Amazon VPC
- Application Load Balancer (ALB)
- EC2 Auto Scaling Group
- Amazon RDS (MySQL)
- NAT Gateway
- Internet Gateway
- CloudWatch (Monitoring)

---
## 📂 Project Structure

```
├── modules/
│ ├── vpc/
│ ├── alb/
│ ├── asg/
│ ├── rds/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
```
---
## 🌍 Architecture Diagram

                               ┌───────────────────────┐
                               │        INTERNET       │
                               └────────────┬──────────┘
                                            │
                                            ▼
                           ┌────────────────────────────────┐
                           │   Application Load Balancer    │
                           │   (Public Subnets - Multi AZ)  │
                           └────────────┬───────────┬───────┘
                                        │           │
                                        │           │
        ================================│===========│================================
                                        │           │
                         Amazon VPC (10.0.0.0/16 - Example)
        =============================================================================

                Availability Zone A                    Availability Zone B
        ────────────────────────────────        ────────────────────────────────

        🟢 Public Subnet A                       🟢 Public Subnet B
        ─────────────────────                     ─────────────────────
        • ALB ENI                                 • ALB ENI
        • NAT Gateway                             • (Optional NAT GW)
        • Route → Internet Gateway                • Route → Internet Gateway


                    │                                           │
                    ▼                                           ▼

        🔵 Private App Subnet A                 🔵 Private App Subnet B
        ─────────────────────────                 ─────────────────────────
        • EC2 Instance (ASG)                     • EC2 Instance (ASG)
        • No Public IP                           • No Public IP
        • SG: Allow from ALB only                • SG: Allow from ALB only
        • Route → NAT Gateway                    • Route → NAT Gateway


                    │                                           │
                    └─────────────── Application Layer ─────────┘
                                    │
                                    ▼

        🟣 Private DB Subnet A                  🟣 Private DB Subnet B
        ──────────────────────────               ─────────────────────────
        • RDS Primary                           • RDS Standby
        • Not Publicly Accessible                • Multi-AZ Failover
        • SG: Allow from EC2 only                • Automatic Replication


        =============================================================================

# 🔥🌲👾AWS Reference Architecture

## Virtual Private Cloud (VPC) on Amazon AWS with ECS using Terraform.

Free to use for personal projects of any size. Recommend donation via Bitcoin (BTC) or Ethereum (ETH) of between $1,000-$5,000 if you are using as part of an organization (more than 2 people). Thanks for your interest!!!
 
BTC: bc1qa5pr9f8zsz4p2frhrh528wqspzpwjasyqg232f
ETH: 0x6C4ca3eb96647F9bA7109B6c6b277e483abe02cB

### Batteries Included - Terraform definitions and Dockerfiles for your cloud project.

#### Support For:

1. AWS Virtual Private Clouds (VPCs)
2. IAM users, groups, and roles (using principle of least privilege).
3. VPN entrypoint (Wireguard).
4. Internet and NAT gateways.
5. Load balancers supporting TLS termination and Docker containers that use TLS.
6. Subnets (default to 3 per VPC).
7. Security: Security groups, network ACLs, multi-VPC architecture including separate Web and Database tiers.
8. Elastic Container Service (ECS):
    1. EC2 Clusters
    2. Services
    3. Task definitions
    4. ECR for Docker payloads
9. S3 to store Terraform state and web assets.
10. CloudFront: CDN support for web assets.
11. DNS: Route53 availability for VPCs, load balancers, subnets, and ECS.
12. Databases (RDS) with read-only replicas and disk encryption:
    1. PostgreSQL
    2. MySQL/MariaDB
    3. MongoDB
    4. OracleDB
    5. MSSQL
13. Docker: Sample Dockerfiles with multi-CPU architecture support (x86 and ARM), compatible with latest MacBook Pros and AWS Graviton processors. Sample files for:
    1. React + SASS + Typescript app
    2. Database schema using JavaScript + Knex
    3. Python Flask and Django apps
    4. Ruby on Rails API
    5. Rust API server
    6. Rust to Web Assembly (WASM) app
    7. Go API server
14. Secrets Manager: Securely store app credentials and secrets. Single library supporting your choice of language/app runtime out of the box.

### Setup Instructions

1. Create new AWS account for best experience.
2. Create new highly privileged IAM role for setup only (eg. global-administrator in Administrators group).
3. Customize Terraform files to suit your environment. Fork (or submit a PR!!!).
4. Configure and initialize Terraform environment:
    1. Install `tfenv`: https://github.com/tfutils/tfenv
    2. Install latest `terraform` release: `tfenv install latest`
    3. Write latest `terraform` version to `.terraform-version` file in root of directory.
    4. Run `terraform validate && terraform init` to initialize project while checking for syntax errors.
    5. Run `terraform plan` to verify infrastructure changes.
    6. Run `terraform apply` to create your cloud infrastructure assets.
    7. Done! Verify your infrastructure by pinging *AWS_IP_ADDRESS*/rust-hello-world
    8. You can publish additional app types by enabling them in Terraform.

### Best Practices

By default, most people on AWS never make it out of the default VPC that gets created with each new AWS account.

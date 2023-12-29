# 🔥🌲👾AWS Reference Architecture

## Starter Architecture for Your Company on AWS Cloud

### ECS Virtual Private Cloud (VPC) on Amazon AWS using Terraform.

Free to use for personal projects of any size. Consider donation/sponsorship via Github of between $10-$5,000 if you are using as part of an organization (more than 2 people). Thanks for your interest!!!

If you or your startup require AWS infrastructure support (hourly or monthly) give us a shout: awsrefarchitects@protonmail.com

## Setup

**Examine and run `bash setup.sh`**, Or:

0. Create new Python virtual environment and install AWS dependency:

    1. `python -m venv ./venv`
    2. `source venv/bin/activate`
    3. `pip install -r requirements.txt`
1. Install `tfenv`.
    1. Instructions: https://github.com/tfutils/tfenv
2. Modifying AWS Infrastructure Definitions (`.tf` files):

    0. Modify `.tf ` files.
    1. `terrafom validate  && terraform init`
    2. `terraform plan`
    3. `terraform apply`
3. On AWS, delete the following insecure defaults:

    1. Default security group: `aws ec2 delete-security-group --group-id ******`
    2. Default Network access control list (ACL): `aws ec2 delete-network-acl --network-acl-id ******`
    3. Default subnets: `aws ec2 delete-subnet --subnet-id ******`
    4. Default route table: `aws ec2 delete-route-table --route-table-id ******`
    5. Default internet gateway:
      - `aws ec2 detach-internet-gateway --internet-gateway-id ****** --vpc-id ******`
      - `aws ec2 delete-internet-gateway --internet-gateway-id ******`
      - OPTIONAL: `aws ec2 delete-egress-only-internet-gateway --egress-only-internet-gateway-id ******`
    6. Default VPC: `aws ec2 delete-vpc --vpc-id ******`
    7. Default DHCP settings: TODO
    - Notes: https://docs.aws.amazon.com/vpc/latest/userguide/delete-vpc.html


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

By default, most people on AWS never make it out of the default VPC that gets created with each new AWS account. This project offers a superior and more secure configuration using multiple VPCs and Transit Gateways for isolation of concerns. What does this mean?

0. The default VPC is not used for anything beyond AWS account defaults. That means it has no access to the internet or the other VPCs that you create.
1. There is a single Web gateway VPC with Internet Gateway - the only way to receive traffic for your private cloud.
2. The Database VPC(s) house your databases, meaning only production applications can connect to the Database VPC for security 
3. Other VPCs exist to house your applications - they communicate to other AWS assets using the default Transit Gateway. They use NAT to exit via **VPC_Web** Internet Gateway 
4. Connect via Wireguard VPN to the second Transit Gateway. If you need to conduct database maintenance, alter the routing table to give yourself access to only the specific database(s) you are working on. By default, there is no SSH access to any EC2 instances in production.
5. Choose whatever load balancer configuration you are most comfortable with. Some recommend one LB per ECS service, others choose to save on costs by sharing a single LB with many services.
6. Either way, your load balancers act as DNS resolvers and SSL/TLS terminators. All ECS services are configured to use TLS certificates in the default configuration. 
7. By default, network ACLs and security groups follow the "least privilege" approach to security. That means that by default the cloud discards all traffic behind **VPC_Web**. In addition, **VPC_Database** only exposes required database ports (eg. 5432 for PostgreSQL databases). To access the production data tier, you will need to modify the network ACL and security group associated with the given subnet which houses the database. This means that a compromise of web-facing assets in the web tier does not lead to a compromise of customer data.
8. For additional security, feel free to disable the VPN attachment and/or VPN transit gateway when not in use.

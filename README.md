# AWS DevOps Assignment

A production-style DevOps demo using Terraform, AWS VPC, EC2, RDS PostgreSQL, Docker, GitHub Actions, and CloudWatch.

## Architecture

```text
                         Internet
                            |
                      Internet Gateway
                            |
                +-----------+-----------+
                |                       |
          Public Subnet A         Public Subnet B
                |                       |
          Staging EC2              Production EC2
          Docker App              Docker App
                |                       |
                +-----------+-----------+
                            |
                    Private DB Subnets
                            |
                       RDS PostgreSQL

GitHub -> GitHub Actions -> Test -> Docker build -> SSH deploy -> EC2
                                         |
                                   CloudWatch Logs
                                         |
                              CloudWatch Dashboards
```

## Repository structure

- `app/` - sample Node.js application
- `terraform/` - AWS infrastructure
- `.github/workflows/` - CI/CD pipelines
- `docs/` - architecture and challenges documentation

## AWS resources

Terraform creates:

- VPC
- 2 public subnets
- 2 private subnets
- Internet Gateway
- NAT Gateway
- Route tables
- Staging EC2
- Production EC2
- RDS PostgreSQL
- Security groups
- IAM role/instance profile
- CloudWatch log group
- Two CloudWatch dashboards

> RDS is private and is not directly exposed to the internet.

## Prerequisites

Install:

- Terraform
- AWS CLI
- Git
- Docker

Configure AWS credentials locally:

```bash
aws configure
aws sts get-caller-identity
```

## Deploy infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set a strong database password.

Then:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Save the outputs:

```bash
terraform output
```

The outputs include the staging and production public IP addresses.

## GitHub Actions setup

Create these GitHub repository secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `STAGING_HOST`
- `PRODUCTION_HOST`
- `EC2_SSH_PRIVATE_KEY`

For a real production implementation, replace long-lived AWS keys with GitHub OIDC and an IAM role.

The deployment workflow uses:

- `develop` branch -> staging
- `main` branch -> production

## SSH key

Create a key:

```bash
ssh-keygen -t ed25519 -C "devops-assignment"
```

The public key must be available to the EC2 instances. Put the public key value in:

```text
terraform.tfvars
```

as `ssh_public_key`.

The private key goes into the GitHub secret:

```text
EC2_SSH_PRIVATE_KEY
```

Never commit the private key.

## Application

The sample application is intentionally simple. It exposes:

- `GET /` - application information
- `GET /health` - health check
- `GET /api/status` - application/database status

Build locally:

```bash
docker build -t devops-assignment-app ./app
docker run --rm -p 3000:3000 devops-assignment-app
```

Open:

```text
http://localhost:3000
```

## Database configuration

The application reads:

```text
DB_HOST
DB_PORT
DB_NAME
DB_USER
DB_PASSWORD
```

Terraform passes the RDS endpoint to the EC2 environment. For this demo, the database password is stored in Terraform variables.

For a real production environment, use AWS Secrets Manager or SSM Parameter Store.

## CI/CD

`ci.yml`:

1. Installs dependencies
2. Runs tests
3. Builds the Docker image

`deploy.yml`:

1. Runs tests
2. Builds Docker image
3. Exports the image as a tarball
4. Copies the image to EC2 over SSH
5. Loads the image with Docker
6. Replaces the running container
7. Performs a health check

Branches:

```text
develop -> staging
main    -> production
```

## Monitoring

Two CloudWatch dashboards are provisioned.

### Infrastructure dashboard

Includes:

- EC2 CPU utilization
- RDS CPU utilization
- RDS database connections
- RDS free storage

### Application dashboard

Includes:

- Application log stream
- EC2 CPU
- RDS connections
- RDS free storage

The EC2 user data installs the CloudWatch agent and collects:

```text
/var/log/app/app.log
```

## Security decisions

- RDS is deployed in private subnets.
- RDS security group only accepts PostgreSQL traffic from the application security group.
- SSH is restricted by `ssh_ingress_cidr` rather than being open to the world.
- Application HTTP traffic is exposed on port 80.
- IAM permissions are limited to the resources required by the instance.
- Sensitive files such as `terraform.tfvars` are excluded by `.gitignore`.
- Terraform state should be stored in an encrypted remote backend for real production use.
- Secrets should be moved to AWS Secrets Manager/SSM in a production implementation.

## Useful commands

```bash
terraform fmt
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

## Demo checklist

1. Show GitHub repository.
2. Show Terraform files.
3. Show `terraform apply` outputs.
4. Open the staging application.
5. Open the production application.
6. Push a change to `develop`.
7. Show GitHub Actions.
8. Show the staging deployment.
9. Merge/push to `main`.
10. Show production deployment.
11. Open CloudWatch dashboards.
12. Show application logs.
13. Explain security decisions.

## Important

This repository is designed as an assignment/demo starter. Before using it in a real production environment:

- use OIDC instead of static AWS credentials,
- use Secrets Manager/SSM,
- use an encrypted remote Terraform backend,
- put EC2 behind an Application Load Balancer,
- use HTTPS,
- use private EC2 subnets where appropriate,
- add backups, alarms, autoscaling, and vulnerability scanning.

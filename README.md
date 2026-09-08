# AWS DevOps Assignment

A simple DevOps project using **Terraform, AWS, Docker, Jenkins, RDS, and CloudWatch**.

## Architecture

```text
                         Internet
                            |
                  Internet Gateway
                            |
              +-------------+-------------+
              |                           |
         Staging EC2                Production EC2
         Docker App                 Docker App
              |                           |
              +-------------+-------------+
                            |
                       RDS PostgreSQL


GitHub → Jenkins → Test → Docker Build → SSH Deploy → EC2
                         |
                    CloudWatch
```

## Repository Structure

```text
app/                  Node.js application
terraform/            AWS infrastructure
docs/                 Project documentation
Jenkinsfile           Jenkins CI/CD pipeline
```

## AWS Resources

Terraform provisions:

* VPC with public and private subnets
* Staging and production EC2 instances
* RDS PostgreSQL
* Security groups
* IAM roles
* CloudWatch logs and dashboards
* Internet Gateway and NAT Gateway

RDS is deployed in private subnets and is not exposed directly to the internet.

## Setup

### Prerequisites

* AWS CLI
* Terraform
* Docker
* Git
* Jenkins

Configure AWS:

```bash
aws configure
aws sts get-caller-identity
```

### Deploy Infrastructure

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Update `terraform.tfvars` with the required values, then run:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Get the EC2 IP addresses:

```bash
terraform output
```

## Jenkins CI/CD

Jenkins handles testing, Docker image creation, and deployment.

```text
develop → Staging EC2
main    → Production EC2
```

Pipeline:

```text
Checkout
   ↓
npm install
   ↓
npm test
   ↓
Docker build
   ↓
SSH/SCP to EC2
   ↓
Run container
   ↓
Health check
```

The pipeline is defined in:

```text
Jenkinsfile
```

Jenkins requires an SSH credential for accessing the EC2 instances. The private key must not be committed to Git.

## Application

The Node.js application provides:

```text
GET /           Application information
GET /health     Health check
GET /api/status Application/database status
```

Run locally:

```bash
docker build -t devops-assignment-app ./app
docker run --rm -p 3000:3000 devops-assignment-app
```

Open:

```text
http://localhost:3000
```

## Monitoring

CloudWatch is used for application logs and infrastructure metrics.

Application logs:

```text
/var/log/app/app.log
```

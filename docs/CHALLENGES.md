# Challenges & Resolutions

## 1. Designing the network

### Challenge
The application and database need connectivity while the database should not be publicly exposed.

### Resolution
A VPC was created with public and private subnets. EC2 application servers are in public subnets for simple assignment demonstration. RDS is placed only in private subnets. The RDS security group permits PostgreSQL traffic only from the application security group.

## 2. Automating application deployment

### Challenge
The Docker image must reach EC2 without manually installing the application.

### Resolution
GitHub Actions builds the Docker image, exports it as a compressed tarball, transfers it to EC2 using SCP, loads it with Docker, and starts a new container. This avoids requiring a container registry for the assignment.

## 3. Environment separation

### Challenge
The assignment requires staging and production deployment logic.

### Resolution
The GitHub Actions deployment workflow uses branch-based environments:

- `develop` -> staging EC2
- `main` -> production EC2

This demonstrates a simple promotion model without creating unnecessary AWS complexity.

## 4. Centralized logging

### Challenge
Container logs should be available centrally for troubleshooting.

### Resolution
The application writes logs to `/var/log/app/app.log`. The directory is mounted into the Docker container and the CloudWatch Agent sends the file to the `/devops-assignment/application` log group.

## 5. Monitoring

### Challenge
Infrastructure and application health need to be visible.

### Resolution
Two CloudWatch dashboards were created:

- Infrastructure dashboard: EC2 and RDS metrics
- Application dashboard: application logs and EC2 metrics

## 6. Security

### Challenge
The project needs reasonable security while remaining easy to demonstrate.

### Resolution
RDS is private, storage is encrypted, security groups restrict database access, SSH access is configurable using a CIDR variable, and sensitive Terraform variables are excluded from Git.

## 7. Production improvements

For a real production environment, the following improvements should be made:

- GitHub Actions OIDC instead of static AWS keys
- AWS Secrets Manager/SSM for database credentials
- encrypted S3 Terraform backend with state locking
- Application Load Balancer
- HTTPS with ACM
- WAF
- private EC2 subnets
- Auto Scaling Group
- RDS Multi-AZ
- CloudWatch alarms/SNS notifications
- image vulnerability scanning
- automated Terraform security scanning

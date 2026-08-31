# Architecture

## Components

### Networking
- One VPC
- Two public subnets
- Two private subnets
- Internet Gateway
- NAT Gateway

### Compute
Two Amazon Linux EC2 instances:

- staging
- production

Each runs the Dockerized Node.js application.

### Database
One PostgreSQL RDS instance in private subnets.

### CI/CD
GitHub Actions performs:

```text
Commit
  |
  +--> Test
  |
  +--> Docker build
  |
  +--> Export image
  |
  +--> SCP to EC2
  |
  +--> docker load
  |
  +--> restart container
  |
  +--> health check
```

### Monitoring

CloudWatch Agent sends application logs to:

```text
/devops-assignment/application
```

CloudWatch dashboards display infrastructure and application information.

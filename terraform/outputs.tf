output "vpc_id" {
  value = aws_vpc.main.id
}

output "staging_public_ip" {
  value = aws_instance.staging.public_ip
}

output "production_public_ip" {
  value = aws_instance.production.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.address
}

output "infrastructure_dashboard" {
  value = aws_cloudwatch_dashboard.infrastructure.dashboard_name
}

output "application_dashboard" {
  value = aws_cloudwatch_dashboard.application.dashboard_name
}

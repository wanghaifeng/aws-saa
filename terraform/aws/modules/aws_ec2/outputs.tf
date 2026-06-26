output "instance_id" {
  value       = aws_instance.this[*].id
  description = "IDs of the EC2 instances."
}

output "public_ip" {
  value       = aws_instance.this[*].public_ip
  description = "Public IP addresses of the EC2 instances."
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "Security group ID created for the instance."
}
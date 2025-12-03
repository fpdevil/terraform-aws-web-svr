output "public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.webserver_instance.public_ip
}

output "vpc_id" {
  description = "The VPC ID from aws_vpc data source"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "The Subnet ID from aws_subnet data source"
  value       = aws_subnet.public.id
}

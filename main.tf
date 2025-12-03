# Resource: EC2 Instance
resource "aws_instance" "webserver_instance" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  availability_zone = var.availability_zone

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  # security_groups = [aws_security_group.webserver_sg.id]

  associate_public_ip_address = true

  # Passing user_data within the terraform script
  user_data                   = file("${path.module}/launch_server.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "WebServerInstance"
  }
}

# Resource: Create Security Group for EC2 instance for Web Traffic
# This ensures proper firewall rules are in place
resource "aws_security_group" "webserver_sg" {
  name        = var.security_group_name
  description = "Security Group for Web Server instance to allow SSH + HTTP"
  vpc_id      = aws_vpc.main.id

  # Allow SSH
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP traffic
  ingress {
    description = "Allow Inbound HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound connections to All
  egress {
    description = "Allow All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServerSecurityGroup"
  }
}

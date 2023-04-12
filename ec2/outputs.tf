output "public_ip" {
  value       = aws_instance.ubuntu_server.public_ip
  description = "The public IP address of the web server"
}

resource "aws_instance" "ubuntu_server" {
  ami           = "ami-04cebc8d6c4f297a3" # Ubuntu 22.04 LTS
  instance_type = "t2.nano"

  tags = {
    Name = "Example-EC2-Linux-Instance"
  }
}

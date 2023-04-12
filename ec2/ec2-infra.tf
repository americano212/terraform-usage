resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port   = var.server_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "ubuntu_server" {
  ami           = "ami-04cebc8d6c4f297a3" # Ubuntu 22.04 LTS
  instance_type = "t2.nano"

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
                #!/bin/bash
                echo "hello,world" > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF

  tags = {
    Name = "terraform-example"
  }
}

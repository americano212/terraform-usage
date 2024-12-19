resource "aws_security_group" "rds_sg" {
  name        = "rds-allow-3306"
  description = "Allow incoming traffic on 3306"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_instance" "default" {
  allocated_storage   = 10
  db_name             = var.db_name
  engine              = "mysql"
  engine_version      = "8.0.33"
  instance_class      = "db.t3.micro"
  username            = var.username
  password            = var.password
  publicly_accessible = true
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

output "rds_endpoint" {
  value = aws_db_instance.default.endpoint
}

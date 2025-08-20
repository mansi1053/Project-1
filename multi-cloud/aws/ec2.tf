resource "aws_instance" "example1" {
  ami = var.aws_ami.id
  instance_type = var.aws_instance_type
  user_data     = file("${path.module}/../scripts/install_nginx.sh")
  
  tags = {
    Name = "ExampleInstance"
  }
}

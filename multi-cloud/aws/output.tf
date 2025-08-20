output "aws_public_ip" {
  value = aws_instance.web_aws.public_ip
}
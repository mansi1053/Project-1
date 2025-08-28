variable "aws_region" {}
variable "aws_instance_type" {}
variable "aws_ami" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {
  type = list
}

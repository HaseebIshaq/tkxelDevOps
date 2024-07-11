provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
}

resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [webservers]
    ${aws_instance.my_ec2_instance.public_ip}
  EOT
  filename = "${path.module}/ansible/inventory"
}

provisioner "ansible" {
  plays = ["${path.module}/ansible/playbook.yml"]
  inventory = local_file.ansible_inventory.filename
  become = true
}

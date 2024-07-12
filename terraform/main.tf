provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0b72821e2f351e396"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  subnet_id     = subnet-054cb907a936367bf # Replace with your subnet ID

  key_name      = "my-key-pair"  # This will be created by Ansible

  tags = {
    Name = "MyEC2Instance"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' ../ansible/playbook.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

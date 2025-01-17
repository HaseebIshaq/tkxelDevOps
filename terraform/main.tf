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
  ami           = "ami-0b72821e2f351e396"  
  instance_type = "t2.micro"
  subnet_id     = "subnet-054cb907a936367bf"

  provisioner "local-exec" {
    command = "ansible-playbook -i '18.206.125.130' ../ansible/playbook.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False" 
    }
  }
}

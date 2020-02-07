resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "main-public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "main-public-1"
  }
}

data "template_file" "user_data_master" {
  template = "${file("user-data/jenkins.tpl")}"
  vars = {
    DEVICE          = var.instance_device_storage
    JENKINS_VERSION = var.jenkins_vers
  }
}

resource "aws_subnet" "main-private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "${var.workload}"
  }
}

resource "aws_instance" "wordpress-jenkins" {
  ami                    = var.AMIS[var.AWS_REGION]
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main-public.id
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  key_name               = aws_key_pair.mykeypair.key_name
  user_data              = "${data.template_file.user_data_master.rendered}"
}

resource "aws_ebs_volume" "jenkins-store" {
  availability_zone = "eu-west-1a"
  size              = 10
  type              = "gp2"
  tags = {
    Name = "jenkins-store"
  }
}

resource "aws_volume_attachment" "jenkins-store-attachment" {
  device_name  = var.instance_device_storage
  volume_id    = aws_ebs_volume.jenkins-store.id
  instance_id  = aws_instance.wordpress-jenkins.id
}
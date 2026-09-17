data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.jenkins_instance_type

  subnet_id = aws_subnet.public_subnet_1.id

  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  user_data = file("${path.module}/jenkins-user-data.sh")

  tags = {
    Name = "${var.project_name}-jenkins"
  }
}

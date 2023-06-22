resource "aws_instance" "jenkins_server" {
  ami             = data.aws_ami.amzn2.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_server_SG.name]
  #user_data       = filebase64("${path.module}/install_jenkins.sh")
  
  user_data = <<-EOF
    #!/bin/bash
    sudo yum install unzip wget tree git -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    sudo amazon-linux-extras install java-openjdk11 -y
    # Add required dependencies for the jenkins package
    sudo yum install jenkins -y
    sudo systemctl daemon-reload
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl status jenkins
    EOF

  tags = {
    Name = "Jenkins"
  }
}
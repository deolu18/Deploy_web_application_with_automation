output "jenkins-url" {
  value = [aws_instance.wordpress-jenkins.*.public_ip]
}

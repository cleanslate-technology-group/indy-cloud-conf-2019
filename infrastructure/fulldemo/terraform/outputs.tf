output "web-ip" {
  value = "${aws_instance.nginx.public_ip}"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags {
    Name        = "${var.name}-vpc"
    Environemnt = "${var.env}"
    Managed     = "${var.managed}"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.name}-igw"
    Environemnt = "${var.env}"
    Managed     = "${var.managed}"
  }
}

# Networking
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.cidr_public}"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"
}

resource "aws_route_table" "public-route-table" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "${var.public_dest_cidr}"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-route-table.id}"
}

# Private/public keys for bastion
# locals {
#   public_key_filename  = "bastion.pub"
#   private_key_filename = "bastion.pem"
# }

# resource "tls_private_key" "generated" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "bastion-key" {
#   key_name   = "bastion-key"
#   public_key = "${tls_private_key.generated.public_key_openssh}"
# }

# resource "local_file" "public_key_openssh" {
#   content  = "${tls_private_key.generated.public_key_openssh}"
#   filename = "${local.public_key_filename}"
# }

# resource "local_file" "private_key_pem" {
#   content  = "${tls_private_key.generated.private_key_pem}"
#   filename = "${local.private_key_filename}"
# }

# # Chmod the private key for use with ssh to AWS bastion
# resource "null_resource" "chmod" {
#   depends_on = ["local_file.private_key_pem"]

#   triggers = {
#     key = "${tls_private_key.generated.private_key_pem}"
#   }

#   provisioner "local-exec" {
#     command = "chmod 400 ${local.private_key_filename}"
#   }
# }

# Security group for Bastion Instance

resource "aws_security_group" "nginx-sg" {
  name        = "nginx-sg"
  description = "A public facing nginx security group"
  vpc_id      = "${aws_vpc.vpc.id}"
}

# The Web Rule Ingress
resource "aws_security_group_rule" "nginx-sg-ingress" {
  description       = "The rule that lets the nginx traffic in"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.myip}"]
  security_group_id = "${aws_security_group.nginx-sg.id}"
}

# The Web Rule Egress
resource "aws_security_group_rule" "nginx-sg-egress" {
  description       = "The rule that lets the nginx traffic out to the world"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["${var.public_dest_cidr}"]
  security_group_id = "${aws_security_group.nginx-sg.id}"
}

# Private/public keys for bastion
locals {
  public_key_filename  = "nginx.pub"
  private_key_filename = "nginx.pem"
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nginx-key" {
  key_name   = "nginx-key"
  public_key = "${tls_private_key.generated.public_key_openssh}"
}

resource "local_file" "public_key_openssh" {
  content  = "${tls_private_key.generated.public_key_openssh}"
  filename = "${local.public_key_filename}"
}

resource "local_file" "private_key_pem" {
  content  = "${tls_private_key.generated.private_key_pem}"
  filename = "${local.private_key_filename}"
}

# Chmod the private key for use with ssh to AWS bastion
resource "null_resource" "chmod" {
  depends_on = ["local_file.private_key_pem"]

  triggers = {
    key = "${tls_private_key.generated.private_key_pem}"
  }

  provisioner "local-exec" {
    command = "chmod 400 ${local.private_key_filename}"
  }
}

# NGINX Instance with webpage
resource "aws_instance" "nginx" {
  depends_on             = ["local_file.private_key_pem"]
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t3.micro"
  subnet_id              = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.nginx-sg.id}"]
  key_name               = "${aws_key_pair.nginx-key.key_name}"

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "file" {
    source      = "start.sh"
    destination = "/tmp/start.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/start.sh",
      "sudo /tmp/start.sh",
    ]
  }

  connection {
    user        = "ubuntu"
    private_key = "${tls_private_key.generated.private_key_pem}"
  }

  tags {
    Name        = "${var.name}-nginx"
    Environemnt = "${var.env}"
    Managed     = "${var.managed}"
  }
}

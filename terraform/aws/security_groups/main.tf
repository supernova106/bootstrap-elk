variable "short_name" {}
variable "vpc_id" {}

resource "aws_security_group" "fluentd_master" {
  name = "${var.short_name}-fluentd-master"
  description = "Allow inbound traffic to fluentd master"
  vpc_id = "${var.vpc_id}"

  ingress { # SSH
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # HTTP
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # HTTPS
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # TCP
    from_port = 24224
    to_port = 24224
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { # ICMP
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "inner" {
  name = "${var.short_name}-inner"
  description = "Allow inbound traffic for all ports"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port=0
    to_port=65535
    protocol = "tcp"
    self = true
  }

  ingress {
    from_port=0
    to_port=65535
    protocol = "udp"
    self = true
  }
}

output "inner_security_group" {
  value = "${aws_security_group.inner.id}"
}

output "fluentd_security_group" {
  value = "${aws_security_group.fluentd_master.id}"
}

variable "instance_ids" {}
variable "security_group_ids" {}
variable "vpc_subnet_ids" {}
variable "short_name" {default = "pubsub"}

# Create a new load balancer
resource "aws_elb" "pubsubelb" {
  name = "${var.short_name}-terraform-elb"
  subnets = ["${split(",", var.vpc_subnet_ids)}"]
  security_groups = ["${split(",", var.security_group_ids)}"]

  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:80"
    interval = 30
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  internal = false
  tags {
    Environment = "production"
  }
}

resource  "aws_elb_attachment" "pubsub" {
  elb = "${aws_elb.pubsubelb.name}"
  instance = "${var.instance_ids}"
}

output "elb_dns_name" {
  value = "${aws_elb.pubsubelb.dns_name}"
}

output "elb_name" {
  value = "${aws_elb.pubsubelb.name}"
}
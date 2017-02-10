variable "security_group_ids" {}
variable "vpc_subnet_ids" {}
variable "short_name" {default = "pubsub"}

# Create a new load balancer
resource "aws_alb" "alb" {
  name            = "${var.short_name}-alb"
  internal        = false
  security_groups = ["${split(",", var.security_group_ids)}"]
  subnets         = ["${split(",", var.vpc_subnet_ids)}"]

  enable_deletion_protection = true
  idle_timeout = 300
  tags {
    Environment = "production"
  }
}

output "alb_arn" {
  value = "${aws_alb.alb.arn}"
}

output "alb_dns" {
  value = "${aws_alb.alb.dns_name}"
}
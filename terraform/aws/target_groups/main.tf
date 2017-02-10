variable "vpc_id" {}
variable "instance_ids" {}
variable "short_name" {default = "pubsub"}

resource "aws_alb_target_group_attachment" "target_groups" {
	target_group_arn = "${aws_alb_target_group.target_groups.arn}"
	target_id = "${element(split(",", var.instance_ids), count.index)}"
	port = 80
}

resource "aws_alb_target_group" "target_groups" {
	name = "${var.short_name}-servers"
	port = 80 
	protocol = "HTTP"
	vpc_id = "${var.vpc_id}"

	stickiness {
		type = "lb_cookie"
		enabled = true
	}

	health_check {
		protocol = "HTTP"
		matcher = "404"
	}	
}

output "target_group_arn" {
  value = "${aws_alb_target_group.target_groups.arn}"
}
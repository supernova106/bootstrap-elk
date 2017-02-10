variable "alb_arn" {}
variable "target_group_arn" {}

resource "aws_alb_listener" "front_end" {
	load_balancer_arn = "${var.alb_arn}"
	port = "80"
	protocol = "HTTP"

	default_action {
		target_group_arn = "${var.target_group_arn}"
		type = "forward"
	}
}

resource "aws_alb_listener" "front_end_ssl" {
	load_balancer_arn = "${var.alb_arn}"
	port = "443"
	protocol = "HTTPS"
	ssl_policy = "ELBSecurityPolicy-2015-05"
	certificate_arn = "arn:aws:iam::821649102857:server-certificate/razersynapse.com-20160411"
	
	default_action {
		target_group_arn = "${var.target_group_arn}"
		type = "forward"
	}
}


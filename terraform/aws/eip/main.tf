variable "instance_id" {}

resource "aws_eip" "lb" {
  instance = "${var.instance_id}"
  vpc      = true
  lifecycle {
    create_before_destroy = "true"
  }
}

output "public_ip" {
	value = "${aws_eip.lb.public_ip}"
}

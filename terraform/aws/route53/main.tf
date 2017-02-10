variable "zone_id" {}
variable "subdomain_name" {}
variable "records" {}
variable "domain" {}

resource "aws_route53_record" "www" {
	zone_id = "${var.zone_id}"
	name = "${var.subdomain_name}.${var.domain}"
	type = "CNAME"
	ttl = "60"
	records = ["${var.records}"]
}


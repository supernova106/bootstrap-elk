variable "short_name" {}
variable "ebs_volume_size" {default = "100"} # size is in gigabytes
variable "ebs_volume_type" {default = "gp2"}
variable "instance_type" {default = "m3.medium.elasticsearch"}
variable "instance_count" {default = "1"}

resource "aws_elasticsearch_domain" "es" {
    domain_name = "${var.short_name}-log"
    elasticsearch_version = "5.1"
    advanced_options {
        "rest.action.multi.allow_explicit_index" = true
    }

    cluster_config {
        instance_type = "${var.instance_type}"
        instance_count = "${var.instance_count}"
    }

    ebs_options {
        ebs_enabled = true
        volume_type = "${var.ebs_volume_type}"
        volume_size = "${var.ebs_volume_size}"
    }

    access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": ["0.0.0.0/0"]}
            }
        }
    ]
}
CONFIG

    snapshot_options {
        automated_snapshot_start_hour = 23
    }

    tags {
      Domain = "application error logs"
    }
}

output "domain_id" {
    value = "${aws_elasticsearch_domain.es.domain_id}"
}

output "arn" {
    value = "${aws_elasticsearch_domain.es.arn}"
}

output "endpoint" {
    value = "${aws_elasticsearch_domain.es.endpoint}"
}
variable "datacenter" {default = "aws"}
variable "zone_id" {default = "Z2SL1GQSG3K40I"}
variable "domain" {default = "razersynapse.com"}
variable "fluentd_master_subdomain_name" {default = "log"}

variable "amis" {
  default = {
    us-east-1 = "ami-49c9295f"
    us-west-2 = "ami-5e63d13e"
  }
}

variable "availability_zones"  {
  default = "a,b,c"
}

variable "long_name" {default = "elk-infra"}
variable "region" {default = "us-east-1"}
variable "short_name" {default = "elk"}
variable "ssh_key" {default = "~/.ssh/id_rsa.pub"}
variable "ssh_username"  {default = "ubuntu"}

variable "fluentd_count" {default = "1"}
variable "fluentd_type" {default = "r3.large"}

variable "es_instance_type" {default = "m3.medium.elasticsearch"}
variable "es_instance_count" {default = "1"}
variable "es_ebs_volume_size" {default = "100"}
variable "es_ebs_volume_type" {default = "gp2"}

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source ="./aws/vpc"
  availability_zones = "${var.availability_zones}"
  short_name = "${var.short_name}"
  long_name = "${var.long_name}"
  region = "${var.region}"
}

module "ssh-key" {
  source ="./aws/ssh"
  short_name = "${var.short_name}"
}

module "security-groups" {
  source = "./aws/security_groups"
  short_name = "${var.short_name}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "iam-profiles" {
  source = "./aws/iam"
  short_name = "${var.short_name}"
}

module "fluentd-node" {
  source = "./aws/instance"
  count = "${var.fluentd_count}"
  datacenter = "${var.datacenter}"
  role = "fluentd-master"
  ec2_type = "${var.fluentd_type}"
  iam_profile = "${module.iam-profiles.elk_iam_instance_profile}"
  ssh_username = "${var.ssh_username}"
  source_ami = "${lookup(var.amis, var.region)}"
  short_name = "${var.short_name}"
  ssh_key_pair = "${module.ssh-key.ssh_key_name}"
  availability_zones = "${module.vpc.availability_zones}"
  security_group_ids = "${module.vpc.default_security_group},${module.security-groups.inner_security_group},${module.security-groups.fluentd_security_group}"
  vpc_subnet_ids = "${module.vpc.subnet_ids}"
  # uncomment below it you want to use remote state for vpc variables
  #availability_zones = "${terraform_remote_state.vpc.output.availability_zones}"
  #security_group_ids = "${terraform_remote_state.vpc.output.default_security_group},${module.security-groups.ui_security_group},${module.security-groups.control_security_group}"
  #vpc_subnet_ids = "${terraform_remote_state.vpc.output.subnet_ids}"
}

module "eip" {
  source = "./aws/eip"
  instance_id = "${module.fluentd-node.ec2_ids}"
}

module "es" {
  source = "./aws/elasticsearch"
  short_name = "${var.short_name}"
  instance_type = "${var.es_instance_type}"
  instance_count = "${var.es_instance_count}"
  ebs_volume_size = "${var.es_ebs_volume_size}"
  ebs_volume_type = "${var.es_ebs_volume_type}"
}

module "route53" {
  source = "./aws/route53"
  subdomain_name = "${var.fluentd_master_subdomain_name}"
  zone_id = "${var.zone_id}"
  domain = "${var.domain}"
  records = "${module.eip.public_ip}"
}
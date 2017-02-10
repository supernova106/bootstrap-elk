variable "short_name" {}
variable "ssh_key" {default = "~/.ssh/elk.pub"}

resource "aws_key_pair" "deployer" {
  key_name = "key-${var.short_name}"
  public_key = "${file(var.ssh_key)}"
}

output "ssh_key_name" {
	value = "${aws_key_pair.deployer.key_name}"
}
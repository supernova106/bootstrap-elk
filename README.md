# Descriptions
- Bootstrap the ELK stack
- Logstash is replaced with fluentd

# Usage
- `ansible-playbook -i plugins/inventory/terraform.py ansible-playbook.yml -vvv --private-key /home/vagrant/.ssh/private_key`
- If you are using EIP, run `terraform plan` `terraform apply` again to refresh the state of the EC2 instances

# Contact
- Binh Nguyen

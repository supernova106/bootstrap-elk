# Descriptions
- Bootstrap the ELK stack
- Logstash is replaced with fluentd

# Usage
- `ansible-playbook -i plugins/inventory/terraform.py ansible-playbook.yml -vvv --private-key /home/vagrant/.ssh/private_key`
- If you are using EIP, run `terraform plan` `terraform apply` again to refresh the state of the EC2 instances

# graylog2
- install graylog2 ansible role: `ansible-galaxy install -n -p ./roles Graylog2.graylog-ansible-role`
- Setup dependencies: `ansible-galaxy install -r roles/Graylog2.graylog-ansible-role/requirements.yml -p ./roles`
- provision ansible-graylog2.yml to your ubuntu box
- Note to update `graylog.server.conf` `rest_transport_uri = http://127.0.0.1:12900/` to `rest_transport_uri = http://<IPV4>:9000/api/`

```
sudo vim /etc/graylog/server/server.conf
sudo service graylog-server restart
```

```
#update nginx server name
sudo vim /etc/nginx/sites-enabled/graylog.conf
sudo service nginx restart
```

- follow http://www.fluentd.org/guides/recipes/graylog2 to install and configure Fluentd agent
- make sure the all the needed ports are accessible

# Contact
- Binh Nguyen

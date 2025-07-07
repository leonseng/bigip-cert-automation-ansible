# BIG-IP SSL Certificate Management

This project provides an Ansible playbook to manage SSL certificates on BIG-IP using the F5Networks.F5_Modules.

![](./docs/images/image.png)

> This is intended for brownfield deployments, hence some non-idempotent patterns are employed.

## Prerequisites

- Docker Compose
- Access to one or more BIG-IP instances with appropriate credentials.

## Usage

### Generate SSL certificate and key pairs

For every certificate:
1. create a `<cert_name>.yaml` file in [host_vars](./inventory/certs/host_vars/),
1. add an entry to the [inventory.ini](./inventory/certs/inventory.ini) file.

Run Ansible playbook to generate SSL certificate and key pairs.
```
docker compose run --remove-orphans ansible -i inventory/certs/inventory.ini playbooks/renew-certs.yaml
```

You should see the key pairs and a `.metadata.yaml` file created the in [.certs](./.certs) directory.

### Load SSL certificate and key pairs to BIG-IP

For every BIG-IP:
1. create a `<bigip_name>.yaml` file in [host_vars](./inventory/bigip/host_vars/),
1. add an entry to the [inventory.ini](./inventory/bigip/inventory.ini) file.

Run Ansible playbook to upload the SSL key pair objects and attach them to the corresponding SSL profiles.
```
docker compose run --remove-orphans ansible -i inventory/bigip/inventory.ini --extra-vars "@.certs/.metadata.yaml" -vvv playbooks/bigip-full-run.yaml
```

## Test

```
openssl s_client -connect <BIG-IP VIP>:443 </dev/null 2>/dev/null | openssl x509 -noout -text | grep DNS:
```

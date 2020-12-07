#!/bin/bash
set -e

# To create http allow rule:
# gcloud compute firewall-rules create allow-http \
# --allow tcp:80,tcp:8080,tcp:443 \
# --target-tags=http-allow \
# --description="Allow HTTP/HTTPS connection" \
# --direction=INGRESS

# To create gitlab-host:
# docker-machine create --driver google \
# --google-project docker-project-295818 \
# --google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts \
# --google-machine-type n1-standard-1 \
# --google-zone europe-west1-b \
# --google-disk-type pd-standard \
# --google-disk-size 100 \
# --google-tags http-allow \
# gitlab-host

tempfile=temp.json
dynamic_inv=dynamo.gcp.yml

# Save dynamic inventory to file
ansible-inventory -i ${dynamic_inv} --list > ${tempfile}

# Set gitlab-host IP as a variable
export ip_var=$(python to_parse.py)
rm -f ${tempfile}

# Set variable 'ip_var' for ansible role 
sed -i 's/^ip_var: .*/ip_var: '$ip_var'/'\
    $PWD/roles/app/defaults/main.yml

# Install community general collection for community.general.docker_compose
ansible-galaxy collection install community.general

# Run ansible role to set gitlab-host settings
ansible-playbook playbooks/main.yml


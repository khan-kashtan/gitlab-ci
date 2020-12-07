#!/bin/bash
set -e

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

#!/bin/bash
set -a
source .env
set +a

echo "Starting Ansible playbook execution"
ansible-playbook -i inventory.ini playbook.yml
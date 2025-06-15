#!/bin/bash
set -a
source .env
set +a

TAGS=$1

echo "Starting Ansible playbook execution"
ansible-playbook -i inventory.ini playbook.yml --tags $TAGS

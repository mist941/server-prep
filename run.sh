#!/bin/bash
set -a
source .env
set +a

TAGS=$1

echo "Starting Ansible playbook execution"

if [ -z "$TAGS" ]; then
  ansible-playbook -i inventory.ini playbook.yml
else
  ansible-playbook -i inventory.ini playbook.yml --tags $TAGS
fi

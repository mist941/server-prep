# Server Preparation Ansible Collection

## Requirements
- Ansible >= 2.14
- Ubuntu 20.04+ or similar Debian-based systems

## Required Collections
```bash
ansible-galaxy collection install -r requirements.yml
```

## Example Usage
```bash
# Create .env file with required variables
cp .env.example .env
# Edit .env with your values

# Run full deployment
./run.sh

# Run specific tags
./run.sh ssh
```

## Required Environment Variables
- ANSIBLE_USER: User for initial connection
- ANSIBLE_PASSWORD: Password for initial connection
- NEW_USER: Username to create
- NEW_USER_PASSWORD: Password for new user
- SSH_PUB_KEY: SSH public key content
- TIMEZONE: Timezone (e.g., "Europe/Kiev")
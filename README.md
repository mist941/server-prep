# Server Preparation with Ansible

This project contains an Ansible playbook for preparing and configuring Ubuntu servers.

## Prerequisites

- Ansible must be installed on the local machine
- SSH access to the target server
- Python installed on the target server

## Quick Start

1. Copy the configuration file:
```bash
cp env.example .env
```

2. Edit the `.env` file with your settings:
```bash
nano .env
```

3. Update `inventory.ini` with your server's IP address

4. Run the playbook:
```bash
./run.sh
```

## Using the Enhanced run.sh Script

The `run.sh` script has been significantly improved and now supports many useful features:

### Basic Commands

```bash
# Run the entire playbook
./run.sh

# Show help
./run.sh --help

# Run only specific tags
./run.sh -t system,updates

# Check changes without applying (dry run)
./run.sh --dry-run

# Run in verbose mode
./run.sh -v

# Show all available tags
./run.sh --list-tags
```

### Script Features

1. **Prerequisites Check**: Automatically checks for Ansible presence and required files
2. **Environment Variables Validation**: Verifies that all required variables are set in `.env`
3. **Colored Output**: Uses colors for better visual perception
4. **Error Handling**: Stops on first error and shows clear error messages
5. **Dry Run Mode**: Allows previewing changes without applying them
6. **Verbose Mode**: Shows more information during execution
7. **Tag Flexibility**: Easy to run only needed parts of the playbook

### Available Tags

- `system` - system updates
- `updates` - install updates
- `time` - timezone configuration
- `user` - user management
- `bash` - bash configuration
- `vim` - vim setup
- `packages` - package installation
- `ssh` - SSH configuration

## Roles

This playbook includes the following roles:

- **system_updates**: Update system packages
- **time_configuration**: Configure timezone
- **user_management**: Create and configure users
- **bash_config**: Configure bash shell
- **vim_setup**: Configure vim editor
- **packages_installation**: Install additional packages
- **ssh_setup**: Configure SSH and keys

## Configuration

All settings are stored in the `.env` file. Configuration example:

```bash
# Ansible Connection Settings
ANSIBLE_USER=ubuntu
ANSIBLE_PASSWORD=your_initial_password

# New User Configuration
NEW_USER=admin
NEW_USER_PASSWORD=secure_password_here

# SSH Public Key
SSH_PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... your-email@example.com"

# System Configuration
TIMEZONE=Europe/Kiev
```

## Project Structure

```
server-prep/
├── run.sh              # Enhanced launch script
├── playbook.yml        # Main playbook
├── inventory.ini       # Inventory file
├── .env               # Environment variables (create from env.example)
├── env.example        # Environment variables example
└── roles/             # Roles directory
    ├── system_updates/
    ├── time_configuration/
    ├── user_management/
    ├── bash_config/
    ├── vim_setup/
    ├── packages_installation/
    └── ssh_setup/
```

## Improvements in run.sh

The new `run.sh` script has the following improvements compared to the original version:

### 🔒 Security and Reliability
- `set -euo pipefail` - stops on errors and uninitialized variables
- Check for presence of all required files
- Environment variables validation before execution

### 🎨 User Interface
- Colored output with different message levels (INFO, SUCCESS, WARNING, ERROR)
- Detailed help with usage examples
- Step-by-step execution messages

### 🛠 Functionality
- Support for multiple command line options
- Dry run mode for safe checking
- Verbose mode for detailed logging
- Ability to view all available tags

### 📊 Monitoring
- Check for Ansible installation
- Validation of all configuration files
- Detailed error messages with resolution tips

### 🔄 Backward Compatibility
- Support for old syntax (passing tags as first argument)
- All existing commands continue to work

## Usage Examples

```bash
# Basic usage
./run.sh

# Run specific roles
./run.sh -t user,ssh

# Check changes without applying
./run.sh --dry-run -t system

# Detailed run with specific tags
./run.sh -v -t packages,vim

# View available tags
./run.sh --list-tags
```

---

**⚠️ Important**: Always test on non-production servers before using in production environments!
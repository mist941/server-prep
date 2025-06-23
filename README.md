# Server Preparation Ansible Project

Basic Ansible automation for initial server setup. Configures essential components such as users, SSH, system updates, and common tools. Designed to work across various Linux hosts.

## 🚀 Features

- ✅ System updates and package upgrades
- ✅ Timezone and time synchronization configuration
- ✅ User management with SSH keys
- ✅ Secure SSH configuration
- ✅ Essential packages installation
- ✅ Vim setup with plugins
- ✅ Custom bash prompt configuration

## 📋 Requirements

- **Ansible**: >= 2.14
- **Supported OS**: Ubuntu 20.04+, Debian 11+
- **Access**: SSH or initial password access to target hosts

## 🔧 Installation

1. **Clone the repository:**
```bash
git clone <your-repo-url>
cd server-prep
```

2. **Install required collections:**
```bash
ansible-galaxy collection install -r requirements.yml
```

3. **Configure environment variables:**
```bash
cp env.example .env
# Edit the .env file with your values
```

## ⚙️ Configuration

### Required Environment Variables

Create a `.env` file with the following variables:

| Variable | Description | Example |
|----------|-------------|---------|
| `ANSIBLE_USER` | User for initial connection | `ubuntu` |
| `ANSIBLE_PASSWORD` | Password for initial connection | `your_password` |
| `NEW_USER` | Name of the new user to create | `admin` |
| `NEW_USER_PASSWORD` | Password for the new user | `secure_password` |
| `SSH_PUB_KEY` | SSH public key content | `ssh-rsa AAAAB3...` |
| `TIMEZONE` | Timezone | `Europe/Kiev` |

### Inventory Configuration

Edit `inventory.ini` and add your servers:

```ini
[servers]
192.168.1.10
192.168.1.11
example.com

[servers:vars]
ansible_user={{ lookup('env', 'ANSIBLE_USER') }}
ansible_password={{ lookup('env', 'ANSIBLE_PASSWORD') }}
ansible_become_password={{ lookup('env', 'ANSIBLE_PASSWORD') }}
```

## 🚀 Usage

### Full Deployment
```bash
./run.sh
```

### Selective Execution by Tags
```bash
# System updates only
./run.sh system,updates

# SSH configuration only
./run.sh ssh

# User and SSH configuration
./run.sh user,ssh
```

### Dry Run (Check mode)
```bash
ansible-playbook -i inventory.ini playbook.yml --check
```

## 🏗️ Project Structure

```
├── ansible.cfg                 # Ansible configuration
├── playbook.yml                # Main playbook
├── inventory.ini               # Host inventory
├── requirements.yml            # Collection dependencies
├── .ansible-lint              # Linting configuration
├── env.example                # Environment variables example
├── run.sh                     # Launch script
└── roles/                     # Ansible roles
    ├── system_updates/        # System updates
    ├── time_configuration/    # Time configuration
    ├── user_management/       # User management
    ├── ssh_setup/            # SSH configuration
    ├── packages_installation/ # Package installation
    ├── vim_setup/            # Vim configuration
    └── bash_config/          # Bash configuration
```

## 🏷️ Available Tags

| Tag | Description |
|-----|-------------|
| `system`, `updates` | System updates |
| `time` | Timezone configuration |
| `user` | User management |
| `ssh` | SSH configuration |
| `packages` | Package installation |
| `vim` | Vim configuration |
| `bash` | Bash configuration |

## 🔒 Security

- SSH root login disabled
- Password authentication disabled
- Key-based authentication only
- User passwords hashed with SHA512
- Sensitive data not logged

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**⚠️ Important**: Always test on non-production servers before using in production environments!
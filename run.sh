#!/bin/bash

# Exit on any error
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
  cat <<EOF
Usage: $0 [OPTIONS] [TAGS]

This script runs the Ansible playbook for server preparation.

OPTIONS:
    -h, --help          Show this help message
    -v, --verbose       Run in verbose mode
    -d, --dry-run       Run playbook in check mode (dry run)
    -t, --tags TAGS     Run only tasks with specified tags
    --list-tags         List all available tags and exit

EXAMPLES:
    $0                          # Run all tasks
    $0 -t system,updates        # Run only system and updates tasks
    $0 --dry-run                # Check what would be changed without applying
    $0 -v -t ssh                # Run ssh tasks in verbose mode

AVAILABLE TAGS:
    system, updates, time, user, bash, vim, packages, ssh

EOF
}

# Function to list available tags
list_tags() {
  print_info "Available tags in the playbook:"
  ansible-playbook -i inventory.ini playbook.yml --list-tags 2>/dev/null |
    grep "TASK TAGS" |
    sed 's/.*TASK TAGS: \[//' |
    sed 's/\]//' |
    tr ',' '\n' |
    sort -u |
    sed 's/^/  - /'
}

# Function to check prerequisites
check_prerequisites() {
  print_info "Checking prerequisites..."

  # Check if ansible is installed
  if ! command -v ansible-playbook &>/dev/null; then
    print_error "ansible-playbook is not installed. Please install Ansible first."
    exit 1
  fi

  # Check if required files exist
  local required_files=(".env" "inventory.ini" "playbook.yml")
  for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
      print_error "Required file '$file' not found!"
      if [[ "$file" == ".env" ]]; then
        print_info "Please copy env.example to .env and configure it:"
        print_info "cp env.example .env"
      fi
      exit 1
    fi
  done

  print_success "All prerequisites met"
}

# Function to load and validate environment variables
load_environment() {
  print_info "Loading environment variables..."

  # Load environment variables
  set -a
  source .env
  set +a

  # Validate required environment variables
  local required_vars=("ANSIBLE_USER" "ANSIBLE_PASSWORD" "NEW_USER" "NEW_USER_PASSWORD" "SSH_PUB_KEY" "TIMEZONE")
  local missing_vars=()

  for var in "${required_vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
      missing_vars+=("$var")
    fi
  done

  if [[ ${#missing_vars[@]} -gt 0 ]]; then
    print_error "Missing required environment variables:"
    printf '  - %s\n' "${missing_vars[@]}"
    print_info "Please check your .env file and ensure all variables are set."
    exit 1
  fi

  print_success "Environment variables loaded successfully"
}

# Function to run ansible playbook
run_playbook() {
  local tags="$1"
  local verbose="$2"
  local dry_run="$3"

  local ansible_cmd="ansible-playbook -i inventory.ini playbook.yml"

  # Add verbose flag if requested
  if [[ "$verbose" == "true" ]]; then
    ansible_cmd+=" -v"
  fi

  # Add check mode if dry run requested
  if [[ "$dry_run" == "true" ]]; then
    ansible_cmd+=" --check"
    print_info "Running in DRY RUN mode - no changes will be made"
  fi

  # Add tags if specified
  if [[ -n "$tags" ]]; then
    ansible_cmd+=" --tags $tags"
    print_info "Running playbook with tags: $tags"
  else
    print_info "Running full playbook"
  fi

  print_info "Executing: $ansible_cmd"
  print_info "Starting Ansible playbook execution..."

  # Execute the command
  if eval "$ansible_cmd"; then
    print_success "Ansible playbook completed successfully!"
  else
    print_error "Ansible playbook failed with exit code $?"
    exit 1
  fi
}

# Main function
main() {
  local tags=""
  local verbose="false"
  local dry_run="false"

  # Parse command line arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
    -h | --help)
      show_usage
      exit 0
      ;;
    -v | --verbose)
      verbose="true"
      shift
      ;;
    -d | --dry-run)
      dry_run="true"
      shift
      ;;
    -t | --tags)
      tags="$2"
      shift 2
      ;;
    --list-tags)
      check_prerequisites
      list_tags
      exit 0
      ;;
    -*)
      print_error "Unknown option: $1"
      show_usage
      exit 1
      ;;
    *)
      # If no option flag, treat as tags for backward compatibility
      if [[ -z "$tags" ]]; then
        tags="$1"
      fi
      shift
      ;;
    esac
  done

  # Run the main workflow
  check_prerequisites
  load_environment
  run_playbook "$tags" "$verbose" "$dry_run"
}

# Run main function with all arguments
main "$@"

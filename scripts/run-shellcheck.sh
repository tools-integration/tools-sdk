#!/bin/bash
set -e

# Parse options
while getopts "h" opt; do
  case ${opt} in
    h)
      echo "Usage: $0 [-h]"
      echo "  -h    Show this help message"
      echo ""
      echo "Runs shellcheck on all .sh files in the scripts/ directory"
      exit 0
      ;;
    \?)
      echo "Invalid option: -${OPTARG}" >&2
      echo "Use -h for help"
      exit 1
      ;;
  esac
done

# Get the project root directory (parent of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Running shellcheck on all shell scripts..."

# Use ubuntu image and install shellcheck, then run it
podman run --rm -v "${PROJECT_ROOT}:/mnt:Z" ubuntu:latest /bin/bash -c "
  apt-get update -qq && apt-get install -y -qq shellcheck > /dev/null 2>&1
  find /mnt/scripts -name '*.sh' -exec shellcheck {} +
"

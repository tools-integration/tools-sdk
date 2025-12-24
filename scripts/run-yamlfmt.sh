#!/bin/bash
set -e

# Default behavior
MODE="format"

# Parse options
while getopts "lh" opt; do
  case ${opt} in
    l)
      MODE="lint"
      ;;
    h)
      echo "Usage: $0 [-l] [-h]"
      echo "  -l    Run in lint mode (check only, no changes)"
      echo "  -h    Show this help message"
      echo ""
      echo "Default: Run in format mode (apply changes)"
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

# Run yamlfmt using podman
if [ "${MODE}" = "lint" ]; then
  echo "Running yamlfmt in lint mode..."
  podman run --rm -v "${PROJECT_ROOT}:/work:Z" -w /work ghcr.io/google/yamlfmt:latest -lint .
else
  echo "Running yamlfmt in format mode..."
  podman run --rm -v "${PROJECT_ROOT}:/work:Z" -w /work ghcr.io/google/yamlfmt:latest .
fi

#!/bin/bash --login
# shellcheck disable=SC1091
set -ex

die() { echo "error: $1"; exit "$2"; }

while getopts "h" opt; do
  case $opt in
    h)
      echo "Usage: $0 [setup|build|install|submit]"
      echo "  setup   - Setup spack environment"
      echo "  build   - Build (concretize) spack environment"
      echo "  install - Install spack environment"
      echo "  submit  - Submit results (placeholder for CDash/reporting)"
      ;;
    *)
      die "Invalid option: -$OPTARG" 1
      ;;
  esac
done
shift $((OPTIND-1))

readonly STEP=$1
[ -z "$STEP" ] && die "no argument given: $*" 2
shift

source scripts/ci/gitlab-ci/setup-vars.sh

# Determine which spack environment to use based on job name
ENV_NAME="frontier"

case ${STEP} in
  setup)
    echo "**********Setup Begin**********"

    # Setup spack if not already available
    if [ -z "$SPACK_ROOT" ]; then
      if [ ! -d "${CI_ROOT_DIR}/spack" ]; then
        git clone -c feature.manyFiles=true https://github.com/spack/spack.git "${CI_ROOT_DIR}/spack"
      fi
      # Source spack environment
      . "${CI_ROOT_DIR}/spack/share/spack/setup-env.sh"
    else
      # Re-source existing spack installation
      . "${SPACK_ROOT}/share/spack/setup-env.sh"
    fi

    # Activate the environment pointing to the config directory
    spack env activate "${CI_SOURCE_DIR}/spack/configs/${ENV_NAME}"

    # Verify environment is active
    spack env status

    # Show configuration
    spack config blame

    echo "**********Setup End**********"
    ;;

  build)
    echo "**********Build Begin**********"

    # Source spack
    if [ -z "$SPACK_ROOT" ]; then
      . "${CI_ROOT_DIR}/spack/share/spack/setup-env.sh"
    else
      . "${SPACK_ROOT}/share/spack/setup-env.sh"
    fi

    # Activate the environment
    spack env activate "${CI_SOURCE_DIR}/spack/configs/${ENV_NAME}"

    # Concretize the environment
    spack concretize -f

    # Show what will be installed
    spack find

    echo "**********Build End**********"
    ;;

  install)
    echo "**********Install Begin**********"

    # Source spack
    if [ -z "$SPACK_ROOT" ]; then
      . "${CI_ROOT_DIR}/spack/share/spack/setup-env.sh"
    else
      . "${SPACK_ROOT}/share/spack/setup-env.sh"
    fi

    # Activate the environment
    spack env activate "${CI_SOURCE_DIR}/spack/configs/${ENV_NAME}"

    # Install the environment with timing and parallel jobs
    spack -t install -j 8 --verbose --fail-fast

    # Show what was installed
    spack find -lv

    echo "**********Install End**********"
    ;;

  submit)
    echo "**********Submit Begin**********"
    # Placeholder for submission to CDash or other reporting systems
    echo "Submit step - currently a placeholder"
    echo "**********Submit End**********"
    ;;

  *)
    die "Unknown step: ${STEP}" 3
    ;;
esac

exit 0

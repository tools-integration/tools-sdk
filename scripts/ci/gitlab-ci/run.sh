#!/bin/bash --login
# shellcheck disable=SC1091
set -ex

die() { echo "error: $1"; exit "$2"; }

while getopts "h" opt; do
  case $opt in
    h)
      echo "Usage: $0 [setup|install|submit]"
      echo "  setup   - Setup spack environment"
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

# Determine which spack environment to use based on job name
export TOOLS_SDK_ROOT=${PWD}

if [ -z "${SPACK_BUILD_DIR}" ]; then
  export SPACK_BUILD_DIR=${PWD}/build
fi

: "${NUM_CORES:=4}"

case ${STEP} in
  setup)
    echo "**********Setup Begin**********"
    git clone -c feature.manyFiles=true https://github.com/spack/spack.git "${SPACK_BUILD_DIR}/spack"

    # Source spack environment
    . "${SPACK_BUILD_DIR}/spack/share/spack/setup-env.sh"

    # Activate the environment pointing to the config directory
    spack env activate --create --without-view --envfile "${PWD}/spack/template" tools-sdk

    if [ -n "${SPACK_BUILDCACHE_DIR}" ]; then
      spack mirror add --unsigned --autopush frontier "file://${SPACK_BUILDCACHE_DIR}"
    fi

    # Verify environment is active
    spack env status

    # Show configuration
    spack config blame

    # Concretize the environment
    spack concretize -f

    # Show what will be installed
    spack find

    # Download archives
    spack fetch --dependencies

    echo "**********Setup End**********"
    ;;

  install)
    echo "**********Install Begin**********"

    . "${SPACK_BUILD_DIR}/spack/share/spack/setup-env.sh"

    # Activate the environment pointing to the config directory
    spack env activate tools-sdk

    # Verify environment is active
    spack env status

    # Show configuration
    spack config blame

    # Install the environment with timing and parallel jobs
    spack -t install "-j$((NUM_CORES*2))" --show-log-on-error --no-check-signature --fail-fast

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

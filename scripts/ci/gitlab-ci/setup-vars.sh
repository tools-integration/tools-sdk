#!/bin/bash --login
set -e

# CI_ROOT_DIR: Parent directory where spack will be cloned
export CI_ROOT_DIR="${CI_PROJECT_DIR}/.."

# CI_SOURCE_DIR: Project source directory
export CI_SOURCE_DIR="${CI_PROJECT_DIR}"

# CI_COMMIT_REF: The commit to checkout (supports downstream pipelines)
if [ -z "$DOWNSTREAM_COMMIT_SHA" ]
then
  export CI_COMMIT_REF="${CI_COMMIT_SHA}"
else
  export CI_COMMIT_REF="${DOWNSTREAM_COMMIT_SHA}"
fi

# CI_ORIGINAL_SHA: Original commit SHA for GitHub status reporting
# For PR branches, the tip commit is a merge commit, so we extract the original
if [ -z "$DOWNSTREAM_BRANCH_REF" ]
then
  ci_branch_ref="${CI_COMMIT_REF_NAME}"
else
  ci_branch_ref="${DOWNSTREAM_BRANCH_REF}"
fi

if [[ ${ci_branch_ref} =~ ^pr[0-9]+_.*$ ]]
then
  # Original commit is the 2nd parent of the merge commit
  export CI_ORIGINAL_SHA=$(git rev-parse "${CI_COMMIT_REF}^2")
else
  export CI_ORIGINAL_SHA="${CI_COMMIT_REF}"
fi

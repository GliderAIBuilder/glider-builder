#!/usr/bin/env bash
# shellcheck disable=SC2129

set -e

# Echo all environment variables used by this script
echo "----------- get_repo -----------"
echo "Environment variables:"
echo "CI_BUILD=${CI_BUILD}"
echo "GITHUB_REPOSITORY=${GITHUB_REPOSITORY}"
echo "RELEASE_VERSION=${RELEASE_VERSION}"
echo "VSCODE_LATEST=${VSCODE_LATEST}"
echo "VSCODE_QUALITY=${VSCODE_QUALITY}"
echo "GITHUB_ENV=${GITHUB_ENV}"

echo "SHOULD_DEPLOY=${SHOULD_DEPLOY}"
echo "SHOULD_BUILD=${SHOULD_BUILD}"
echo "-------------------------"

# git workaround
if [[ "${CI_BUILD}" != "no" ]]; then
  git config --global --add safe.directory "/__w/$( echo "${GITHUB_REPOSITORY}" | awk '{print tolower($0)}' )"
fi

GLIDER_BRANCH="onboarding"
echo "Cloning glider ${GLIDER_BRANCH}..."

mkdir -p vscode
cd vscode || { echo "'vscode' dir not found"; exit 1; }

git init -q
# Use GitHub token for authentication if available
if [[ -n "$GLIDER_CLONE_GH_TOKEN" ]]; then
  git remote add origin "https://${GLIDER_CLONE_GH_TOKEN}@github.com/GliderOrg/gliderapp.git"
else
  echo "Warning: GLIDER_CLONE_GH_TOKEN not set. Cloning may fail if repository is private."
  git remote add origin "https://github.com/GliderOrg/gliderapp.git"
fi

# Allow callers to specify a particular commit to checkout via the
# environment variable GLIDER_COMMIT.  We still default to the tip of the
# ${GLIDER_BRANCH} branch when the variable is not provided.  Keeping
# GLIDER_BRANCH as "main" ensures the rest of the script (and downstream
# consumers) behave exactly as before.
if [[ -n "${GLIDER_COMMIT}" ]]; then
  echo "Using explicit commit ${GLIDER_COMMIT}"
  git fetch --depth 1 origin "${GLIDER_COMMIT}"
  git checkout "${GLIDER_COMMIT}"
else
  git fetch --depth 1 origin "${GLIDER_BRANCH}"
  git checkout "${GLIDER_BRANCH}"
fi

MS_TAG=$( jq -r '.version' "package.json" )
MS_COMMIT=$GLIDER_BRANCH # Glider - MS_COMMIT doesn't seem to do much
GLIDER_VERSION=$( jq -r '.gliderVersion' "product.json" ) # Glider added this

if [[ -n "${GLIDER_RELEASE}" ]]; then # Glider added GLIDER_RELEASE as optional to bump manually
  RELEASE_VERSION="${MS_TAG}${GLIDER_RELEASE}"
else
  GLIDER_RELEASE=$( jq -r '.gliderRelease' "product.json" )
  RELEASE_VERSION="${MS_TAG}${GLIDER_RELEASE}"
fi
# Glider - RELEASE_VERSION is later used as version (1.0.3+RELEASE_VERSION), so it MUST be a number or it will throw a semver error in glider


echo "RELEASE_VERSION=\"${RELEASE_VERSION}\""
echo "MS_COMMIT=\"${MS_COMMIT}\""
echo "MS_TAG=\"${MS_TAG}\""

cd ..

# for GH actions
if [[ "${GITHUB_ENV}" ]]; then
  echo "MS_TAG=${MS_TAG}" >> "${GITHUB_ENV}"
  echo "MS_COMMIT=${MS_COMMIT}" >> "${GITHUB_ENV}"
  echo "RELEASE_VERSION=${RELEASE_VERSION}" >> "${GITHUB_ENV}"
  echo "GLIDER_VERSION=${GLIDER_VERSION}" >> "${GITHUB_ENV}" # Glider added this
fi



echo "----------- get_repo exports -----------"
echo "MS_TAG ${MS_TAG}"
echo "MS_COMMIT ${MS_COMMIT}"
echo "RELEASE_VERSION ${RELEASE_VERSION}"
echo "GLIDER VERSION ${GLIDER_VERSION}"
echo "----------------------"


export MS_TAG
export MS_COMMIT
export RELEASE_VERSION
export GLIDER_VERSION

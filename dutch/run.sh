#!/usr/bin/with-contenv bashio
set -euo pipefail

APP_DIR="/data/dutch"
LOCK_HASH_FILE="/data/dutch-dependency-lock.sha256"

REPO="$(bashio::config 'dutch_repo')"
REF="$(bashio::config 'dutch_ref')"
UPDATE_ON_START="$(bashio::config 'update_on_start')"

if [ -z "${REPO}" ]; then
  bashio::log.fatal "dutch_repo is empty"
  exit 1
fi

if [ -z "${REF}" ]; then
  bashio::log.fatal "dutch_ref is empty"
  exit 1
fi

clone_fresh() {
  bashio::log.info "Cloning Dutch from ${REPO}, ref ${REF}"
  rm -rf "${APP_DIR}"
  git clone --depth 1 --branch "${REF}" "${REPO}" "${APP_DIR}"
}

update_existing() {
  bashio::log.info "Updating Dutch from ${REPO}, ref ${REF}"
  git -C "${APP_DIR}" remote set-url origin "${REPO}"
  git -C "${APP_DIR}" fetch --depth 1 origin "${REF}"
  git -C "${APP_DIR}" reset --hard FETCH_HEAD
  git -C "${APP_DIR}" clean -fd -e node_modules
}

if [ ! -d "${APP_DIR}/.git" ]; then
  clone_fresh
elif [ "${UPDATE_ON_START}" = "true" ]; then
  update_existing
else
  bashio::log.info "Using cached Dutch source in ${APP_DIR}"
fi

if [ ! -f "${APP_DIR}/package.json" ]; then
  bashio::log.fatal "${APP_DIR}/package.json was not found"
  exit 1
fi

cd "${APP_DIR}"

if [ -f package-lock.json ]; then
  CURRENT_LOCK_HASH="$(sha256sum package-lock.json | awk '{print $1}')"
  INSTALL_COMMAND="npm ci --omit=dev"
else
  CURRENT_LOCK_HASH="$(sha256sum package.json | awk '{print $1}')"
  INSTALL_COMMAND="npm install --omit=dev"
fi

PREVIOUS_LOCK_HASH=""
if [ -f "${LOCK_HASH_FILE}" ]; then
  PREVIOUS_LOCK_HASH="$(cat "${LOCK_HASH_FILE}")"
fi

if [ ! -d node_modules ] || [ "${CURRENT_LOCK_HASH}" != "${PREVIOUS_LOCK_HASH}" ]; then
  bashio::log.info "Installing Dutch npm dependencies"
  ${INSTALL_COMMAND}
  echo "${CURRENT_LOCK_HASH}" > "${LOCK_HASH_FILE}"
else
  bashio::log.info "Dutch npm dependencies are already installed"
fi

export NODE_ENV="production"
export PORT="3000"

bashio::log.info "Starting Dutch on port ${PORT}"
exec npm start

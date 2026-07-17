#!/usr/bin/with-contenv bashio
set -euo pipefail

APP_DIR="/opt/dutch"

if [ ! -f "${APP_DIR}/package.json" ]; then
  bashio::log.fatal "${APP_DIR}/package.json was not found"
  exit 1
fi

cd "${APP_DIR}"

INTERNAL_GAME_LOG_DIR="${APP_DIR}/game-logs"
DEFAULT_GAME_LOG_DIR="/share/dutch/logs"
CONFIGURED_GAME_LOG_DIR="$(bashio::config "game_log_dir" || true)"
EXTERNAL_GAME_LOG_DIR="${CONFIGURED_GAME_LOG_DIR:-${DEFAULT_GAME_LOG_DIR}}"

if [[ "${EXTERNAL_GAME_LOG_DIR}" != /share/* ]]; then
  bashio::log.warning "Ignoring non-share Dutch game log path ${EXTERNAL_GAME_LOG_DIR}; using ${DEFAULT_GAME_LOG_DIR}"
  EXTERNAL_GAME_LOG_DIR="${DEFAULT_GAME_LOG_DIR}"
fi

mkdir -p "${EXTERNAL_GAME_LOG_DIR}"

if [ -L "${INTERNAL_GAME_LOG_DIR}" ]; then
  if [ "$(readlink "${INTERNAL_GAME_LOG_DIR}")" != "${EXTERNAL_GAME_LOG_DIR}" ]; then
    rm "${INTERNAL_GAME_LOG_DIR}"
    ln -s "${EXTERNAL_GAME_LOG_DIR}" "${INTERNAL_GAME_LOG_DIR}"
  fi
elif [ -d "${INTERNAL_GAME_LOG_DIR}" ]; then
  for entry in "${INTERNAL_GAME_LOG_DIR}"/* "${INTERNAL_GAME_LOG_DIR}"/.[!.]* "${INTERNAL_GAME_LOG_DIR}"/..?*; do
    [ -e "${entry}" ] || continue
    name="$(basename "${entry}")"
    target="${EXTERNAL_GAME_LOG_DIR}/${name}"
    if [ -e "${target}" ]; then
      cmp -s "${entry}" "${target}" && continue
      target="${EXTERNAL_GAME_LOG_DIR}/internal-merge-$(date +%s)-${name}"
    fi
    cp -a "${entry}" "${target}"
  done
  backup_dir="${INTERNAL_GAME_LOG_DIR}.merged-$(date +%s)"
  mv "${INTERNAL_GAME_LOG_DIR}" "${backup_dir}"
  ln -s "${EXTERNAL_GAME_LOG_DIR}" "${INTERNAL_GAME_LOG_DIR}"
  bashio::log.info "Merged ${backup_dir} into ${EXTERNAL_GAME_LOG_DIR} and linked ${INTERNAL_GAME_LOG_DIR}"
elif [ -e "${INTERNAL_GAME_LOG_DIR}" ]; then
  backup_path="${INTERNAL_GAME_LOG_DIR}.merged-$(date +%s)"
  mv "${INTERNAL_GAME_LOG_DIR}" "${backup_path}"
  ln -s "${EXTERNAL_GAME_LOG_DIR}" "${INTERNAL_GAME_LOG_DIR}"
  bashio::log.warning "Moved unexpected internal log path ${backup_path} and linked ${INTERNAL_GAME_LOG_DIR}"
else
  ln -s "${EXTERNAL_GAME_LOG_DIR}" "${INTERNAL_GAME_LOG_DIR}"
fi

export NODE_ENV="production"
export PORT="3000"
export DUTCH_GAME_LOG_DIR="${INTERNAL_GAME_LOG_DIR}"

bashio::log.info "Starting bundled Dutch on port ${PORT}"
bashio::log.info "Saving Dutch game logs to ${DUTCH_GAME_LOG_DIR} -> ${EXTERNAL_GAME_LOG_DIR}"
exec npm start

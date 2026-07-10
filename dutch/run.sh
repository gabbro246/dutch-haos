#!/usr/bin/with-contenv bashio
set -euo pipefail

APP_DIR="/opt/dutch"

if [ ! -f "${APP_DIR}/package.json" ]; then
  bashio::log.fatal "${APP_DIR}/package.json was not found"
  exit 1
fi

cd "${APP_DIR}"

export NODE_ENV="production"
export PORT="3000"

bashio::log.info "Starting bundled Dutch on port ${PORT}"
exec npm start

FROM ghcr.io/home-assistant/base:latest

ARG BUILD_VERSION
ARG BUILD_ARCH

LABEL \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.type="app" \
  io.hass.arch="${BUILD_ARCH}" \
  org.opencontainers.image.title="Dutch Home Assistant Add-on" \
  org.opencontainers.image.description="Home Assistant wrapper for the Dutch card game" \
  org.opencontainers.image.source="https://github.com/gabbro246/dutch-haos"

RUN apk add --no-cache \
  nodejs \
  npm

WORKDIR /opt/dutch

COPY app/package*.json ./
RUN npm ci --omit=dev

COPY app/ ./

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

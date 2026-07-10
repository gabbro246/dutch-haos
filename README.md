# Dutch Home Assistant add-on repository

This repository wraps [`gabbro246/dutch`](https://github.com/gabbro246/dutch) as a Home Assistant add-on.

It contains a vendored copy of the Dutch app in [`dutch/app`](dutch/app). The add-on runs that bundled source so Home Assistant can detect updates through the normal add-on `version` in [`dutch/config.yaml`](dutch/config.yaml).

The [`Sync Dutch source`](.github/workflows/sync-dutch.yml) workflow copies new upstream changes from `gabbro246/dutch`, records the upstream commit in [`dutch/SOURCE_REVISION`](dutch/SOURCE_REVISION), bumps the add-on version, and commits the result.

## Install

1. In Home Assistant, open Settings -> Add-ons -> Add-on Store.
2. Add the repository `https://github.com/gabbro246/dutch-haos` as a custom add-on repository.
3. Install the `Dutch` add-on.
4. Start it.

The add-on exposes the Dutch web UI on container port `3000`, mapped to host port `3000` by default. You can change the host port in the add-on Network settings if needed.

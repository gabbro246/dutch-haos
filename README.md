# Dutch Home Assistant add-on repository

This repository wraps [`gabbro246/dutch`](https://github.com/gabbro246/dutch) as a Home Assistant add-on.

It contains a vendored copy of the Dutch app in [`dutch/app`](dutch/app). The add-on runs that bundled source while Home Assistant detects updates through the add-on `version` in [`dutch/config.yaml`](dutch/config.yaml).

The [`Sync Dutch source`](.github/workflows/sync-dutch.yml) workflow copies new upstream changes from `gabbro246/dutch`, records the upstream commit in [`dutch/SOURCE_REVISION`](dutch/SOURCE_REVISION), bumps the Home Assistant add-on version, keeps the Dutch app package version in sync, and commits the result.

The workflow does not poll on a schedule. It runs manually or when `gabbro246/dutch` sends a `repository_dispatch` event named `dutch-updated` after a push to `main`. The sync copies Dutch source and bumps the Home Assistant add-on version so Home Assistant can notice the update. A separate wrapper workflow bumps the add-on version for `dutch-haos` changes that do not touch the vendored Dutch app.

Add this workflow to `gabbro246/dutch` as `.github/workflows/notify-dutch-haos.yml`:

```yaml
name: Notify Dutch HAOS

on:
  push:
    branches:
      - main

jobs:
  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Dispatch dutch-haos sync
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.DUTCH_HAOS_DISPATCH_TOKEN }}
          script: |
            await github.rest.repos.createDispatchEvent({
              owner: 'gabbro246',
              repo: 'dutch-haos',
              event_type: 'dutch-updated'
            });
```

`DUTCH_HAOS_DISPATCH_TOKEN` must be a fine-grained GitHub token with access to `gabbro246/dutch-haos` and the repository permission `Contents: read and write`.

## Install

1. In Home Assistant, open Settings -> Add-ons -> Add-on Store.
2. Add the repository `https://github.com/gabbro246/dutch-haos` as a custom add-on repository.
3. Install the `Dutch` add-on.
4. Start it.

The add-on exposes the Dutch web UI on container port `3000`, mapped to host port `3000` by default. You can change the host port in the add-on Network settings if needed.

Game logs are written to the configured `game_log_dir`, which defaults to `/share/dutch/logs`. The add-on maps Home Assistant's `share` folder read-write, so this path is backed by the Home Assistant share folder.

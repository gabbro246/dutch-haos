# Dutch

Runs the Dutch card game from `gabbro246/dutch` as a Home Assistant add-on.

The add-on includes the Dutch source code in `app/` and runs that bundled copy. Updates are published by copying the upstream Dutch source into this repository and bumping the add-on version.

## Updates

The repository workflow checks `gabbro246/dutch`, updates `app/` when the upstream commit changes, and bumps `config.yaml`. Home Assistant then shows the add-on update normally.

## Network

Container port `3000` is mapped to host port `3000` by default.

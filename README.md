# Dutch Home Assistant add-on repository

This repository wraps [`gabbro246/dutch`](https://github.com/gabbro246/dutch) as a Home Assistant add-on.

It does not contain a copy of the Dutch app source. The add-on clones the Dutch repository into `/data/dutch` when it starts. With `update_on_start` enabled, restarting the add-on pulls the current `main` branch before starting the Node server.

## Install

1. In Home Assistant, open Settings -> Add-ons -> Add-on Store.
2. Add the repository `https://github.com/gabbro246/dutch-haos` as a custom add-on repository.
5. Install the `Dutch` add-on.
6. Start it.

The add-on exposes the Dutch web UI on container port `3000`, mapped to host port `3000` by default. You can change the host port in the add-on Network settings if needed.



# Dutch Home Assistant add-on repository

This repository wraps [`gabbro246/dutch`](https://github.com/gabbro246/dutch) as a Home Assistant add-on.

It intentionally does not contain a copy of the Dutch app source. The add-on clones the Dutch repository into `/data/dutch` when it starts. With `update_on_start` enabled, restarting the add-on pulls the current `main` branch before starting the Node server.

## Install

1. Create the GitHub repository `https://github.com/gabbro246/dutch-haos`.
2. Upload these files exactly as they are, preserving the folder structure.
3. In Home Assistant, open Settings -> Add-ons -> Add-on Store.
4. Add this repository URL as a custom add-on repository.
5. Install the `Dutch` add-on.
6. Start it.

The add-on exposes the Dutch web UI on container port `3000`, mapped to host port `3000` by default. You can change the host port in the add-on Network settings if needed.

## Updating Dutch

Default behavior:

- Dutch source is stored in `/data/dutch` inside the add-on data volume.
- On add-on start, the wrapper fetches `gabbro246/dutch` and resets the local copy to the configured ref.
- If `package-lock.json` or `package.json` changes, dependencies are reinstalled.

So, after changing `gabbro246/dutch`, restart this add-on to pick up the change.

## nginx

A matching nginx example is in `examples/nginx-dutch.winklerav.net.conf`.

For your setup, nginx should proxy `dutch.winklerav.net` to the Home Assistant host IP and the Dutch add-on host port, for example:

```nginx
proxy_pass http://192.168.0.4:3000;
```

Keep the WebSocket headers. Dutch uses Socket.IO.

# Dutch add-on documentation

This add-on wraps the Dutch Node application without copying its source into this repository.

## How updates work

When the add-on starts, it clones or updates the repository configured in `dutch_repo` and checks out `dutch_ref`.

With the default settings, restarting the add-on is enough to pick up new commits from `gabbro246/dutch` on `main`.

## Web UI

Open the web UI from the add-on page, or reverse proxy the mapped host port with nginx.

The app uses Socket.IO, so the reverse proxy must support WebSockets.

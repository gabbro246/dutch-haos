# Dutch add-on documentation

This add-on wraps the bundled Dutch Node application from this repository.

## How updates work

The Dutch source is copied into `app/` and built into the add-on image. When `gabbro246/dutch` changes, the repository workflow copies the latest source, records the upstream commit, bumps the add-on version, and pushes a commit. Home Assistant detects that version bump as a normal add-on update.

## Web UI

Open the web UI from the add-on page, or reverse proxy the mapped host port with nginx.

The app uses Socket.IO, so the reverse proxy must support WebSockets.

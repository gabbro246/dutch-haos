# Dutch

Runs the Dutch card game from `gabbro246/dutch` as a Home Assistant add-on.

The add-on does not include the Dutch source code. It downloads the configured repository and ref when the add-on starts.

## Configuration

| Option | Default | Meaning |
| --- | --- | --- |
| `dutch_repo` | `https://github.com/gabbro246/dutch.git` | Source repository to clone. |
| `dutch_ref` | `main` | Branch or tag to run. |
| `update_on_start` | `true` | Fetch the configured ref each time the add-on starts. |

## Network

Container port `3000` is mapped to host port `3000` by default.

Use your nginx add-on to reverse proxy `dutch.winklerav.net` to the Home Assistant host IP and this port.

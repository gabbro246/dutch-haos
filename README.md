# Dutch for Home Assistant

Dutch is a local multiplayer card game that runs as a Home Assistant app. Play
in a browser with other people on your network or against bots.

## What it does

The app hosts [Dutch](https://github.com/gabbro246/dutch) directly on your Home
Assistant system. Games open in a browser, and completed game logs can be kept
in Home Assistant's shared storage.

## Install

1. In Home Assistant, open **Settings → Apps → App store**.
2. Open the three-dot menu in the top-right corner and select
   **Repositories**.
3. Add `https://github.com/gabbro246/dutch-haos`.
4. Find **Dutch** in the app store and select **Install**.
5. Start the app, then select **Open Web UI** to play.

## Play on another device

On a phone, tablet, or computer connected to the same network, open:

`http://homeassistant.local:3000`

If that address is unavailable, replace `homeassistant.local` with the local
IP address of your Home Assistant system. If you change the app's port under
**Network**, use the new port in the address.

## Versions

The Home Assistant app uses Calendar Versioning in the form
`YYYY.M.RELEASE`. The bundled Dutch game keeps its own separate Semantic
Version, shown in the app changelog.

## License

[MIT](LICENSE)

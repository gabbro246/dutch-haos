# Dutch app documentation

## Start the app

After installation, select **Start** on the Dutch app page. Enable
**Start on boot** if you want Dutch to start automatically with Home
Assistant.

Select **Open Web UI** to open the game. From there, create a game, add bots if
wanted, and choose the game length.

## Play on another device

Other phones, tablets, and computers on the same network can open:

`http://homeassistant.local:3000`

If that address is unavailable, replace `homeassistant.local` with the local
IP address of your Home Assistant system. If you change the app's port under
**Network**, use the new port in the address.

## Game logs

Important start and stop messages appear on the app's **Log** tab. Completed
game logs are saved in Home Assistant's shared storage under
`/share/dutch/logs`.

You can change the log folder with `game_log_dir` on the app's
**Configuration** tab.

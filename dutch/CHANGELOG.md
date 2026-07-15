# Changelog

## 1.1.8

- Add Home Assistant-accessible saved game logs under `/share/dutch/logs`.
- Show saved game log text files from the Dutch web UI.
- Send important game lifecycle events to the Home Assistant add-on log.

## 1.1.7

- Update the Dutch source sync workflow to use Dutch package versions for Home Assistant add-on updates.
- Document the required upstream push dispatch trigger.

## 1.1.6

- Bundle Dutch source in the add-on image instead of downloading it at startup.
- Add automated upstream sync workflow with add-on version bumps.

## 1.0.1

- Simplified Readmes and removed unneccessary files

## 1.0.0

- Initial Home Assistant add-on wrapper for `gabbro246/dutch`.
- Clones Dutch source at add-on startup.
- Exposes the Dutch web UI on port 3000.

# remote-mac-lock

Remote screen lock utility for macOS. Trigger your Mac's lock screen from any device on the same network.

## Install

> macOS only.

```bash
curl -fsSL https://raw.githubusercontent.com/stevejkang/remote-mac-lock/main/install.sh | bash
```

Once installed, visit `http://<your-local-ip>:61000/lock` from any device on the same network.

## Basic Authentication

Authentication is optional. To enable it, edit `~/.config/remote-mac-lock/.env`:

```
BASIC_AUTH_USER=admin
BASIC_AUTH_PASS=your-password
```

Then restart the service to apply:

```bash
launchctl kickstart -k gui/$(id -u)/com.stevejkang.remote-mac-lock
```

## Restart

```bash
launchctl kickstart -k gui/$(id -u)/com.stevejkang.remote-mac-lock
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/stevejkang/remote-mac-lock/main/uninstall.sh | bash
```

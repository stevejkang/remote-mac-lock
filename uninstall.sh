#!/bin/bash
set -e

PLIST_NAME="com.stevejkang.remote-mac-lock.plist"
INSTALL_BIN="/usr/local/bin/remote-mac-lock"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
CONFIG_DIR="$HOME/.config/remote-mac-lock"

echo "==> Uninstalling remote-mac-lock..."

launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
rm -f "$LAUNCH_AGENTS_DIR/$PLIST_NAME"
sudo rm -f "$INSTALL_BIN"
rm -rf "$CONFIG_DIR"

echo "==> remote-mac-lock uninstalled."

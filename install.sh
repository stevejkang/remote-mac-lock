#!/bin/bash
set -e

REPO="stevejkang/remote-mac-lock"
PLIST_NAME="com.stevejkang.remote-mac-lock.plist"
INSTALL_BIN="/usr/local/bin/remote-mac-lock"
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
CONFIG_DIR="$HOME/.config/remote-mac-lock"

echo "==> Installing remote-mac-lock..."

# Detect architecture
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  arm64)  ARCH="arm64" ;;
  *)
    echo "Error: unsupported architecture: $ARCH"
    exit 1
    ;;
esac

# Download latest release
LATEST=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$LATEST" ]; then
  echo "Error: failed to fetch latest release"
  exit 1
fi

ASSET="remote-mac-lock-darwin-${ARCH}"
URL="https://github.com/$REPO/releases/download/${LATEST}/${ASSET}"

echo "==> Downloading $LATEST for darwin/$ARCH..."
curl -fsSL -o /tmp/remote-mac-lock "$URL"
chmod +x /tmp/remote-mac-lock
sudo mv /tmp/remote-mac-lock "$INSTALL_BIN"

# Configure environment
mkdir -p "$CONFIG_DIR"
if [ ! -f "$CONFIG_DIR/.env" ]; then
  cat > "$CONFIG_DIR/.env" << 'EOF'
BASIC_AUTH_USER=
BASIC_AUTH_PASS=
EOF
  echo "==> Created $CONFIG_DIR/.env"
  echo "    Set BASIC_AUTH_USER and BASIC_AUTH_PASS for basic authentication (optional)."
fi

# Install launchd plist
echo "==> Installing launchd service..."
mkdir -p "$LAUNCH_AGENTS_DIR"

curl -fsSL "https://raw.githubusercontent.com/$REPO/$LATEST/$PLIST_NAME" \
  | sed "s|/usr/local/bin/remote-mac-lock|$INSTALL_BIN|g" \
  > "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

# Load service
launchctl unload "$LAUNCH_AGENTS_DIR/$PLIST_NAME" 2>/dev/null || true
launchctl load "$LAUNCH_AGENTS_DIR/$PLIST_NAME"

echo ""
echo "==> remote-mac-lock installed successfully!"
echo "    Config: $CONFIG_DIR/.env"
echo "    Logs:   /tmp/remote-mac-lock.stdout.log"
echo "    URL:    http://<your-local-ip>:61000/lock"
echo ""
echo "To restart after editing .env:"
echo "    launchctl kickstart -k gui/\$(id -u)/$PLIST_NAME"
echo ""
echo "To uninstall:"
echo "    curl -fsSL https://raw.githubusercontent.com/stevejkang/remote-mac-lock/main/uninstall.sh | bash"

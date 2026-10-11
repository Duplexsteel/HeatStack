#!/usr/bin/env bash
# HeatStack one-click server install (Ubuntu/Debian, run as root). Same command installs AND updates; your settings/key stay.
#   curl -fsSL <site>/install.sh | sudo bash                     (downloads the latest server package)
#   sudo bash install.sh HeatStack-server-0.5.2.tar.gz            (from a package you already have)
# Everything lives in /opt/tradebot (program) and /var/lib/tradebot (your .env with the key, state, logs). Nothing else is touched.
set -euo pipefail
PKG_URL="${TRADEBOT_PKG_URL:-https://github.com/Duplexsteel/HeatStack/releases/download/v0.5.2/HeatStack-server-0.5.2.tar.gz}"            # TODO: set to the website's latest server package when it exists
[ "$(id -u)" = 0 ] || { echo "Run as root: sudo bash install.sh"; exit 1; }
command -v apt-get >/dev/null || { echo "This installer supports Ubuntu/Debian (apt). Other Linux: see the manual steps on the website."; exit 1; }

echo "== HeatStack server install =="
apt-get update -qq && apt-get install -y -qq python3 python3-venv curl tar >/dev/null
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
if [ -n "${1:-}" ]; then cp "$1" "$TMP/pkg.tar.gz"
elif [ -n "$PKG_URL" ]; then curl -fsSL "$PKG_URL" -o "$TMP/pkg.tar.gz"
else echo "No package given. Usage: sudo bash install.sh HeatStack-server-<version>.tar.gz"; exit 1; fi
tar -xzf "$TMP/pkg.tar.gz" -C "$TMP"; SRC="$TMP/tradebot"
[ -f "$SRC/app/main.py" ] || { echo "Package looks wrong (no app/main.py) - nothing changed."; exit 1; }

id tradebot >/dev/null 2>&1 || useradd --system --home /var/lib/tradebot --shell /usr/sbin/nologin tradebot
mkdir -p /var/lib/tradebot /opt/tradebot
systemctl stop tradebot 2>/dev/null || true
rm -rf /opt/tradebot/app /opt/tradebot/bots                       # program only - your data in /var/lib/tradebot stays
cp -r "$SRC/app" "$SRC/bots" /opt/tradebot/
[ -d /opt/tradebot/venv ] || python3 -m venv /opt/tradebot/venv
/opt/tradebot/venv/bin/pip install -q --upgrade pip
/opt/tradebot/venv/bin/pip install -q -r "$SRC/requirements-server.txt"
chown -R tradebot:tradebot /var/lib/tradebot; chmod 700 /var/lib/tradebot
cp "$SRC/tradebot.service" /etc/systemd/system/tradebot.service
systemctl daemon-reload && systemctl enable --now tradebot >/dev/null
sleep 3
if systemctl is-active --quiet tradebot; then
  IP=$(hostname -I 2>/dev/null | awk '{print $1}')
  echo; echo "== HeatStack $(cat "$SRC/VERSION") is running =="
  echo "The page only listens on this server itself (safe). Open it from your PC through an SSH tunnel:"
  echo "    ssh -L 8765:127.0.0.1:8765 $(logname 2>/dev/null || echo root)@${IP:-<server-ip>}"
  echo "  then browse to http://127.0.0.1:8765 and finish the setup (terms, Kraken key, dry run)."
  echo "Phone access: install Tailscale on the server and your phone, then enable phone access with a PIN in Setup."
  echo "Logs: journalctl -u tradebot -n 50     Update: run this installer again with the new package."
else
  echo "HeatStack did not start - last log lines:"; journalctl -u tradebot -n 30 --no-pager; exit 1
fi

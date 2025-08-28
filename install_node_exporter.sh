#!/bin/sh
# One-click installation and configuration of prometheus-node-exporter-lua for OpenWRT

set -e

echo "[1/4] Installing required packages..."
# opkg update
opkg install prometheus-node-exporter-lua prometheus-node-exporter-lua-netstat prometheus-node-exporter-lua-nat_traffic

echo "[2/4] Configuring prometheus-node-exporter-lua..."
CONFIG_FILE="/etc/config/prometheus-node-exporter-lua"

if [ -f "$CONFIG_FILE" ]; then
    # Set listen_interface to lan
    uci set prometheus-node-exporter-lua.main.listen_interface='lan'
    # Disable IPv6 listening (set to 1 if needed)
    uci set prometheus-node-exporter-lua.main.listen_ipv6='0'
    # Set listen port (default 9100, change if needed)
    uci set prometheus-node-exporter-lua.main.listen_port='9100'
    uci commit prometheus-node-exporter-lua
else
    echo "Config file $CONFIG_FILE not found, installation may have failed."
    exit 1
fi

echo "[3/4] Restarting service..."
/etc/init.d/prometheus-node-exporter-lua restart

echo "[4/4] Enabling service at startup..."
/etc/init.d/prometheus-node-exporter-lua enable

echo "Installation completed."
echo "Node Exporter metrics at: http://<router-ip>:9100/metrics"

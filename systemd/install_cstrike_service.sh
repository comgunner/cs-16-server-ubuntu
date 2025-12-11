#!/bin/bash

# This script must be executed with SUDO by the administrator user (e.g. gunner),
# since it installs the service in /etc/systemd/system/.

# --- VARIABLES AND DEFAULT CONFIGURATION ---
SERVER_USER="csserver"
SERVICE_NAME_BASE="cstrike_server"
WORKING_DIR="/home/$SERVER_USER/27020"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME_BASE.service"
DEFAULT_PORT="27015" # Standard CS 1.6 game port

# --- IP DETECTION FUNCTIONS ---

# Detect Public IP (WAN)
get_public_ip() {
    # We use timeout in case the web service is slow
    echo $(timeout 5 curl -s ifconfig.me)
}

# Detect Local IP (LAN - Robust method using ip addr)
get_local_ip() {
    # Finds the first valid IPv4 address on any interface (except 'lo')
    IP_ADDR=$(ip addr show | awk '/inet / && !/127.0.0.1/ && !/inet6/ {print $2}' | cut -d/ -f1 | head -n 1)
    echo "$IP_ADDR"
}

# --- USER INTERACTION ---

echo "--- CS 1.6 Server Configuration ---"
echo ""

# 1. Detect IPs
PUBLIC_IP=$(get_public_ip)
LOCAL_IP=$(get_local_ip)

# 2. Choose IP
echo "Detected IP (Required for the '+ip' command of hlds_run):"
# Shows '(Empty)' if detection failed
echo "  1) Public IP (WAN): ${PUBLIC_IP:-Empty} (Required if the server is public)"
echo "  2) Local IP (LAN): ${LOCAL_IP:-Empty} (For playing on a local network or VM)"
echo "  3) Enter Manually"
echo ""
read -p "Choose the IP option (1/2/3) or enter the IP directly: " IP_CHOICE

case "$IP_CHOICE" in
    1) SERVER_IP="$PUBLIC_IP" ;;
    2) SERVER_IP="$LOCAL_IP" ;;
    3) read -p "Enter the IP manually: " SERVER_IP ;;
    *) # If the user enters an IP directly
        if [[ "$IP_CHOICE" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            SERVER_IP="$IP_CHOICE"
        else
            echo "Invalid option. Using Local IP by default (${LOCAL_IP:-Empty})."
            SERVER_IP="$LOCAL_IP"
        fi
        ;;
esac

# Final fallback if all detections fail (in case SERVER_IP is empty)
if [ -z "$SERVER_IP" ]; then
    echo "WARNING! Could not determine the IP. Using 0.0.0.0 (may fail)."
    SERVER_IP="0.0.0.0"
fi

echo ""
echo "Selected IP: $SERVER_IP"
echo ""

# 3. Choose Port
read -p "Enter the game port [Default: $DEFAULT_PORT]: " CUSTOM_PORT
if [ -z "$CUSTOM_PORT" ]; then
    SERVER_PORT="$DEFAULT_PORT"
else
    SERVER_PORT="$CUSTOM_PORT"
fi

echo "Selected Port: $SERVER_PORT"
echo "----------------------------------------"
echo ""

# --- FINAL START COMMAND (DIRECT, WITHOUT SCREEN) ---
HLDS_RUN_COMMAND="$WORKING_DIR/hlds_run -game cstrike +ip $SERVER_IP +port $SERVER_PORT -pingboost 3 +maxplayers 22 +map de_dust"

# --- VERIFICATIONS AND PREPARATION ---

if ! id "$SERVER_USER" >/dev/null 2>&1; then
    echo "Error: The user '$SERVER_USER' does not exist. Please create it first."
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "Installing 'curl' (necessary for public IP detection)..."
    sudo apt update
    sudo apt install -y curl
fi

# --- CREATE AND CONFIGURE THE SYSTEMD SERVICE ---

echo "Creating the systemd service file: $SERVICE_PATH"

# We use 'tee' to write the service file
tee "$SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description=Counter-Strike 1.6 Dedicated Server
Wants=network-online.target
After=network-online.target

[Service]
WorkingDirectory=$WORKING_DIR
# We use /bin/bash -c to ensure the full shell environment
ExecStart=/bin/bash -c "$HLDS_RUN_COMMAND"
User=$SERVER_USER
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# --- ENABLE AND START THE SERVICE ---
echo "Reloading systemd daemons..."
sudo systemctl daemon-reload

echo "Enabling the service $SERVICE_NAME_BASE (automatic start on boot)..."
sudo systemctl enable $SERVICE_NAME_BASE

echo "Starting the server $SERVICE_NAME_BASE..."
sudo systemctl restart $SERVICE_NAME_BASE

echo "Installation complete. Check the status with: sudo systemctl status $SERVICE_NAME_BASE"
echo "To view the console log if it fails, use: journalctl -u $SERVICE_NAME_BASE -f"
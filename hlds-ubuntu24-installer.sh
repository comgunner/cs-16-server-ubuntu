#!/bin/bash
# ubuntu24_cs16_hlds_install.sh
# CS 1.6 HLDS auto installer for Ubuntu Server 24.04
# Steps 1 -> 4.2 + downloads systemd installer (Step 5) WITHOUT installing the service
# Optional: --no-steam enables DProto dual protocol support before testing.

set -euo pipefail

# ==========================================
# COLORS
# ==========================================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# ==========================================
# CONFIG
# ==========================================
SERVER_USER="csserver"
SERVER_HOME="/home/${SERVER_USER}"
SERVER_DIR="${SERVER_HOME}/27020"
STEAMCMD_TGZ="steamcmd_linux.tar.gz"
PRECONF_TGZ="linuxserver+dprotoDualnosteam.tar.gz"
PRECONF_URL="https://downloads.sourceforge.net/project/cs16serverpreconfiguredlinux/beta2014/linuxserver%2BdprotoDualnosteam.tar.gz"
STEAMCMD_URL="http://media.steampowered.com/client/steamcmd_linux.tar.gz"
SERVICE_INSTALLER_URL="https://downloads.sourceforge.net/project/cs16serverpreconfiguredlinux/beta2014/systemd/install_cstrike_service.sh"
DPROTO_CFG_URL="https://downloads.sourceforge.net/project/cs16serverpreconfiguredlinux/beta2014/dual_protocol/dproto.cfg"
DEFAULT_GAME_PORT="27020"  # Same as guide

# Optional DProto flag (dual protocol: Steam + Non-Steam)
USE_DPROTO=0

# ==========================================
# ARGUMENT PARSING
# ==========================================
while [[ $# -gt 0 ]]; do
    case "$1" in
        --no-steam|--enable-dproto)
            USE_DPROTO=1
            shift
            ;;
        -h|--help)
            echo "Usage: sudo bash $0 [--no-steam]"
            echo
            echo "Options:"
            echo "  --no-steam / --enable-dproto   Enable DProto dual protocol support"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: ${1}${RESET}"
            echo "Usage: sudo bash $0 [--no-steam]"
            exit 1
            ;;
    esac
done

# ==========================================
# HELPERS
# ==========================================

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo -e "${RED}This script must be run as root.${RESET}"
        echo "Example: sudo bash ${0}"
        exit 1
    fi
}

pause_msg() {
    echo ""
    read -rp "Press ENTER to continue..."
}

get_public_ip() {
    timeout 5 curl -s ifconfig.me || true
}

get_local_ip() {
    ip -4 addr show scope global | awk '/inet / {print $2}' | cut -d/ -f1 | head -n 1
}

run_as_csserver() {
    local CMD="$1"
    sudo -u "${SERVER_USER}" -H bash -lc "${CMD}"
}

# ==========================================
# 1. DEPENDENCIES
# ==========================================

step_dependencies() {
    echo "==========================================="
    echo " [1] Enabling i386 and installing packages"
    echo "==========================================="

    echo "1.1 Enabling i386 architecture..."
    dpkg --add-architecture i386 || true

    echo "Updating package list and system..."
    apt update
    apt upgrade -y

    echo "Installing basic utilities..."
    apt install -y wget curl tar mailutils unzip nano tmux net-tools binutils

    echo "Installing 32-bit compatibility libraries for HLDS..."
    apt install -y \
        lib32gcc-s1 \
        lib32z1 \
        libbz2-1.0:i386 \
        libc6:i386 \
        libncursesw6:i386 \
        libstdc++6:i386 \
        libgcc-s1:i386

    echo "Installing additional GoldSrc engine libraries..."
    apt install -y \
        libsdl2-2.0-0:i386 \
        libfontconfig1:i386 \
        libxtst6:i386

    echo -e "${GREEN}Dependencies installed successfully.${RESET}"
    echo
}

# ==========================================
# 2. SERVICE USER
# ==========================================

step_create_user() {
    echo "==========================================="
    echo " [2] Creating service user 'csserver'"
    echo "==========================================="

    if id "${SERVER_USER}" >/dev/null 2>&1; then
        echo "User ${SERVER_USER} already exists. Skipping creation."
    else
        echo "Creating user ${SERVER_USER} with home ${SERVER_HOME}..."
        useradd -m -s /bin/bash "${SERVER_USER}"

        echo "Set a password for ${SERVER_USER}:"
        passwd "${SERVER_USER}"
    fi

    mkdir -p "${SERVER_HOME}"
    chown -R "${SERVER_USER}:${SERVER_USER}" "${SERVER_HOME}"

    echo -e "${GREEN}User ${SERVER_USER} is ready.${RESET}"
    echo
}

# ==========================================
# 3. SERVER INSTALLATION
# ==========================================

step_server_install() {
    echo "==========================================="
    echo " [3.1] Downloading preconfigured server"
    echo "==========================================="

    run_as_csserver "cd '${SERVER_HOME}' && \
        echo 'Downloading preconfigured HLDS package...' && \
        wget -O '${PRECONF_TGZ}' '${PRECONF_URL}' && \
        echo 'Extracting package...' && \
        tar xvzf '${PRECONF_TGZ}'"

    echo
    echo "==========================================="
    echo " [3.2] Downloading and preparing SteamCMD"
    echo "==========================================="

    run_as_csserver "cd '${SERVER_HOME}' && \
        echo 'Downloading SteamCMD...' && \
        wget -O '${STEAMCMD_TGZ}' '${STEAMCMD_URL}' && \
        tar xvfz '${STEAMCMD_TGZ}' && \
        chmod +x steamcmd.sh"

    echo
    echo -e "${CYAN}${BOLD}SteamCMD will open now.${RESET}"
    echo -e "${YELLOW}${BOLD}Inside SteamCMD, type these commands in order:${RESET}"
    echo -e "  ${GREEN}force_install_dir /home/${SERVER_USER}/27020/${RESET}"
    echo -e "  ${GREEN}login anonymous${RESET}"
    echo -e "  ${GREEN}app_update 90 validate${RESET}"
    echo -e "  ${GREEN}exit${RESET}"
    echo
    echo -e "${BLUE}This will download and validate the HLDS binaries for Counter-Strike 1.6 (App ID 90).${RESET}"
    pause_msg

    run_as_csserver "cd '${SERVER_HOME}' && ./steamcmd.sh"

    echo
    echo "==========================================="
    echo " [3.3] Library fixes and steamclient.so"
    echo "==========================================="

    run_as_csserver "cd '${SERVER_DIR}' && \
        echo 'Applying library fixes...' && \
        if [ -f libstdc++.so.6 ]; then mv libstdc++.so.6 libstdc++.so.6.BAK; fi && \
        if [ -f libgcc_s.so.1 ]; then mv libgcc_s.so.1 libgcc_s.so.1.BAK; fi && \
        mkdir -p ~/.steam/sdk32 && \
        ln -sf '/home/${SERVER_USER}/linux32/steamclient.so' ~/.steam/sdk32/steamclient.so"

    echo -e "${GREEN}Library adjustments completed.${RESET}"
    echo
}

# ==========================================
# 3.4 OPTIONAL DPROTO CONFIGURATION (--no-steam)
# ==========================================

step_dproto_optional() {
    if [[ "${USE_DPROTO}" -ne 1 ]]; then
        return
    fi

    echo "==========================================="
    echo " [3.4] Optional DProto configuration (--no-steam)"
    echo "==========================================="

    # Create and download dproto.cfg
    run_as_csserver "cd '${SERVER_DIR}' && \
        echo 'Creating dproto.cfg and downloading configuration...' && \
        touch dproto.cfg && \
        wget -O dproto.cfg '${DPROTO_CFG_URL}'"

    # Add dp_rejmsg_nosteam47 line to server.cfg if not present
    run_as_csserver "
        CFG='${SERVER_DIR}/cstrike/server.cfg'; \
        if [ -f \"\$CFG\" ]; then \
            if ! grep -q 'dp_rejmsg_nosteam47' \"\$CFG\"; then \
                echo 'Adding dp_rejmsg_nosteam47 message to server.cfg...'; \
                printf '%s\n' 'dp_rejmsg_nosteam47 \"Sorry, you'\''re using an old client, download a newer version.\"' >> \"\$CFG\"; \
            else \
                echo 'dp_rejmsg_nosteam47 already present in server.cfg. Skipping.'; \
            fi; \
        else \
            echo 'WARNING: server.cfg not found at ${SERVER_DIR}/cstrike/server.cfg. Skipping dp_rejmsg_nosteam47 line.'; \
        fi
    "

    echo -e "${GREEN}DProto dual-protocol configuration applied (dproto.cfg + reject message).${RESET}"
    echo
}

# ==========================================
# 4. MANUAL SERVER TEST (TU VERSIÓN)
# ==========================================

step_manual_test() {
    echo "==========================================="
    echo " [4] Manual server test (4.2)"
    echo "==========================================="

    echo "Detecting server IP addresses..."
    PUBLIC_IP="$(get_public_ip || true)"
    LOCAL_IP="$(get_local_ip || true)"

    echo ""
    echo "Detected IPs:"
    echo "  1) Public (WAN): ${PUBLIC_IP:-Not detected}"
    echo "  2) Local (LAN):  ${LOCAL_IP:-Not detected}"
    echo "  3) Enter custom IP"
    echo ""
    read -rp "Choose option (1/2/3) or type an IP directly: " IP_CHOICE

    case "${IP_CHOICE}" in
        1) SERVER_IP="${PUBLIC_IP}" ;;
        2) SERVER_IP="${LOCAL_IP}" ;;
        3)
            read -rp "Enter the IP you want to use: " SERVER_IP
            ;;
        *)
            if [[ "${IP_CHOICE}" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
                SERVER_IP="${IP_CHOICE}"
            else
                echo "Invalid option. Using detected LAN IP by default: ${LOCAL_IP:-0.0.0.0}"
                SERVER_IP="${LOCAL_IP:-0.0.0.0}"
            fi
            ;;
    esac

    if [[ -z "${SERVER_IP}" ]]; then
        echo "Could not determine a valid IP. Using 0.0.0.0 (may fail)."
        SERVER_IP="0.0.0.0"
    fi

    echo ""
    echo "Selected IP for TEST: ${SERVER_IP}"
    echo ""

    read -rp "Enter game port [default: ${DEFAULT_GAME_PORT}]: " PORT_INPUT
    if [[ -z "${PORT_INPUT}" ]]; then
        GAME_PORT="${DEFAULT_GAME_PORT}"
    else
        GAME_PORT="${PORT_INPUT}"
    fi

    echo ""
    echo "The CS 1.6 server will be started for a MANUAL TEST with:"
    echo "  IP   : ${SERVER_IP}"
    echo "  Port : ${GAME_PORT}"
    echo ""
    echo "Equivalent command:"
    echo "  cd ${SERVER_DIR}"
    echo "  ./hlds_run -game cstrike +ip ${SERVER_IP} +port ${GAME_PORT} -pingboost 3 +maxplayers 22 +map de_dust -autoupdate"
    echo ""
    echo -e "${YELLOW}${BOLD}Press ENTER to launch the test server...${RESET}"
    echo -e "${RED}${BOLD}To stop the server, press: Ctrl + C${RESET}"
    echo "---------------------------------------------------------"
    pause_msg

    echo -e "${CYAN}Launching test server in foreground...${RESET}"
    
    # Lanzar hlds_run como csserver EN SEGUNDO PLANO
    set +e
    run_as_csserver "cd '${SERVER_DIR}' && \
        ./hlds_run -game cstrike +ip '${SERVER_IP}' +port '${GAME_PORT}' -pingboost 3 +maxplayers 22 +map de_dust -autoupdate" &
    HLDS_WRAPPER_PID=$!

    # Trap para Ctrl + C: mata el hlds_run pero mantiene vivo el script
    trap 'echo -e "\nStopping test server..."; kill ${HLDS_WRAPPER_PID} 2>/dev/null || true; wait ${HLDS_WRAPPER_PID} 2>/dev/null || true; trap - INT' INT

    # Esperar a que termine el server (por Ctrl + C o por error)
    wait ${HLDS_WRAPPER_PID}
    STATUS=$?

    # Restaurar comportamiento normal
    trap - INT
    set -e

    echo ""
    echo -e "${BLUE}The manual test (hlds_run) has finished with exit code ${STATUS}.${RESET}"
    echo "If you pressed Ctrl + C, this is expected."
    echo
}

# ==========================================
# 5. DOWNLOAD SYSTEMD INSTALLER (DO NOT RUN IT)
# ==========================================

step_download_service_installer() {
    echo "==========================================="
    echo " [5] Downloading systemd installer (not running it)"
    echo "==========================================="

    run_as_csserver "cd '${SERVER_HOME}' && \
        echo 'Downloading install_cstrike_service.sh...' && \
        wget -O install_cstrike_service.sh '${SERVICE_INSTALLER_URL}'"

    chmod +x "${SERVER_HOME}/install_cstrike_service.sh"

    echo ""
    echo -e "${GREEN}File ${SERVER_HOME}/install_cstrike_service.sh downloaded and marked as executable.${RESET}"
    echo ""
    echo "When you want to install the persistent systemd service:"
    echo "  1) Log in as a sudo-capable user (e.g. your admin account)."
    echo "  2) Run:"
    echo "       sudo /home/${SERVER_USER}/install_cstrike_service.sh"
    echo "  3) That script will ask you for the IP (public or LAN) and port for the permanent service."
    echo ""
    echo "NOTE: This current script ONLY:"
    echo "  - Installs dependencies"
    echo "  - Prepares HLDS"
    echo "  - (Optionally) configures DProto if --no-steam is used"
    echo "  - Runs one manual test"
    echo "  - Downloads the systemd installer script"
    echo
}

# ==========================================
# MAIN
# ==========================================

require_root

echo "==========================================="
echo " CS 1.6 HLDS Installer - Ubuntu 24.04"
echo " Service user : ${SERVER_USER}"
echo " Server path  : ${SERVER_DIR}"
if [[ "${USE_DPROTO}" -eq 1 ]]; then
    echo " DProto (dual protocol): ENABLED (--no-steam)"
else
    echo " DProto (dual protocol): DISABLED (Steam only)"
fi
echo "==========================================="
echo

step_dependencies
step_create_user
step_server_install
step_dproto_optional
step_manual_test
step_download_service_installer

echo "==========================================="
echo " INSTALLATION FLOW COMPLETED"
echo "==========================================="
echo "CS 1.6 server installed at: ${SERVER_DIR}"
echo "Systemd installer script at:"
echo "  /home/${SERVER_USER}/install_cstrike_service.sh"
echo ""
echo "You can manually run another test with:"
echo "  sudo -u ${SERVER_USER} -H bash -lc \"cd '${SERVER_DIR}' && ./hlds_run -game cstrike +ip YOUR_IP +port ${DEFAULT_GAME_PORT} -pingboost 3 +maxplayers 22 +map de_dust -autoupdate\""
echo ""
echo "To install the persistent service later:"
echo "  sudo /home/${SERVER_USER}/install_cstrike_service.sh"
echo "==========================================="


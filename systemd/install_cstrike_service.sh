#!/bin/bash

# Este script debe ejecutarse con SUDO por el usuario administrador (ej. gunner),
# ya que instala el servicio en /etc/systemd/system/.

# --- VARIABLES Y CONFIGURACIÓN PREDETERMINADA ---
SERVER_USER="csserver"
SERVICE_NAME_BASE="cstrike_server"
WORKING_DIR="/home/$SERVER_USER/27020"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME_BASE.service"
DEFAULT_PORT="27015" # Puerto de juego estándar de CS 1.6

# --- FUNCIONES DE DETECCIÓN DE IP ---

# Detectar IP Pública (WAN)
get_public_ip() {
    # Usamos timeout por si el servicio web está lento
    echo $(timeout 5 curl -s ifconfig.me)
}

# Detectar IP Local (LAN - Método robusto usando ip addr)
get_local_ip() {
    # Busca la primera dirección IPv4 válida en cualquier interfaz (excepto 'lo')
    IP_ADDR=$(ip addr show | awk '/inet / && !/127.0.0.1/ && !/inet6/ {print $2}' | cut -d/ -f1 | head -n 1)
    echo "$IP_ADDR"
}

# --- INTERACCIÓN CON EL USUARIO ---

echo "--- Configuración del Servidor CS 1.6 ---"
echo ""

# 1. Detectar IPs
PUBLIC_IP=$(get_public_ip)
LOCAL_IP=$(get_local_ip)

# 2. Elegir IP
echo "IP detectada (Necesaria para el comando '+ip' de hlds_run):"
# Muestra '(Vacío)' si la detección falló
echo "  1) IP Pública (WAN): ${PUBLIC_IP:-Vacío} (Necesaria si el servidor es público)"
echo "  2) IP Local (LAN): ${LOCAL_IP:-Vacío} (Para jugar en red local o VM)"
echo "  3) Introducir Manualmente"
echo ""
read -p "Elija la opción de IP (1/2/3) o introduzca la IP directamente: " IP_CHOICE

case "$IP_CHOICE" in
    1) SERVER_IP="$PUBLIC_IP" ;;
    2) SERVER_IP="$LOCAL_IP" ;;
    3) read -p "Introduzca la IP manualmente: " SERVER_IP ;;
    *) # Si el usuario introduce una IP directamente
        if [[ "$IP_CHOICE" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            SERVER_IP="$IP_CHOICE"
        else
            echo "Opción no válida. Usando IP Local por defecto (${LOCAL_IP:-Vacío})."
            SERVER_IP="$LOCAL_IP"
        fi
        ;;
esac

# Fallback final si todas las detecciones fallan (en caso de que SERVER_IP esté vacío)
if [ -z "$SERVER_IP" ]; then
    echo "¡ADVERTENCIA! No se pudo determinar la IP. Usando 0.0.0.0 (puede fallar)."
    SERVER_IP="0.0.0.0"
fi

echo ""
echo "IP seleccionada: $SERVER_IP"
echo ""

# 3. Elegir Puerto
read -p "Introduzca el puerto del juego [Predeterminado: $DEFAULT_PORT]: " CUSTOM_PORT
if [ -z "$CUSTOM_PORT" ]; then
    SERVER_PORT="$DEFAULT_PORT"
else
    SERVER_PORT="$CUSTOM_PORT"
fi

echo "Puerto seleccionado: $SERVER_PORT"
echo "----------------------------------------"
echo ""

# --- COMANDO DE INICIO FINAL (DIRECTO, SIN SCREEN) ---
HLDS_RUN_COMMAND="$WORKING_DIR/hlds_run -game cstrike +ip $SERVER_IP +port $SERVER_PORT -pingboost 3 +maxplayers 4 +map de_dust"

# --- VERIFICACIONES Y PREPARACIÓN ---

if ! id "$SERVER_USER" >/dev/null 2>&1; then
    echo "Error: El usuario '$SERVER_USER' no existe. Por favor, créalo primero."
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo "Instalando 'curl' (necesario para la detección de IP pública)..."
    sudo apt update
    sudo apt install -y curl
fi

# --- CREAR Y CONFIGURAR EL SERVICIO SYSTEMD ---

echo "Creando el archivo de servicio systemd: $SERVICE_PATH"

# Usamos 'tee' para escribir el archivo de servicio
tee "$SERVICE_PATH" > /dev/null <<EOF
[Unit]
Description=Counter-Strike 1.6 Dedicated Server
Wants=network-online.target
After=network-online.target

[Service]
WorkingDirectory=$WORKING_DIR
# Usamos /bin/bash -c para asegurar el entorno de shell completo
ExecStart=/bin/bash -c "$HLDS_RUN_COMMAND"
User=$SERVER_USER
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# --- HABILITAR Y ARRANCAR EL SERVICIO ---
echo "Recargando demonios de systemd..."
sudo systemctl daemon-reload

echo "Habilitando el servicio $SERVICE_NAME_BASE (inicio automático en el boot)..."
sudo systemctl enable $SERVICE_NAME_BASE

echo "Iniciando el servidor $SERVICE_NAME_BASE..."
sudo systemctl restart $SERVICE_NAME_BASE

echo "Instalación completada. Verifica el estado con: sudo systemctl status $SERVICE_NAME_BASE"
echo "Para ver el log de la consola si falla, usa: journalctl -u $SERVICE_NAME_BASE -f"

#!/bin/bash

# ==============================================================================
# SCRIPT: monitor_recursos_alertas.sh
# AUTOR: Álvaro Blanco Garay
# DESCRIPCIÓN: Monitoriza el estado de la RAM, CPU y Disco en servidores Linux.
# ==============================================================================

# Definición de umbrales máximos (porcentajes)
UMBRAL_DISCO=80
UMBRAL_RAM=85

LOG_FILE="/var/log/sysadmin_monitor.log"
FECHA=$(date "+%Y-%m-%d %H:%M:%S")

echo "==========================================" >> "$LOG_FILE"
echo " Reporte de Estado de Sistema - $FECHA" >> "$LOG_FILE"
echo "==========================================" >> "$LOG_FILE"

# 1. Comprobación de Disco en raíz (/)
USO_DISCO=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
if [ "$USO_DISCO" -gt "$UMBRAL_DISCO" ]; then
    echo "[ALERTA] Uso de disco crítico: $USO_DISCO%" >> "$LOG_FILE"
else
    echo "[OK] Uso de disco adecuado: $USO_DISCO%" >> "$LOG_FILE"
fi

# 2. Comprobación de Memoria RAM
RAM_TOTAL=$(free | awk '/Mem:/ {print $2}')
RAM_USADA=$(free | awk '/Mem:/ {print $3}')
USO_RAM=$(( RAM_USADA * 100 / RAM_TOTAL ))

if [ "$USO_RAM" -gt "$UMBRAL_RAM" ]; then
    echo "[ALERTA] Uso de RAM elevado: $USO_RAM%" >> "$LOG_FILE"
else
    echo "[OK] Uso de RAM dentro de parámetros normales: $USO_RAM%" >> "$LOG_FILE"
fi

echo "Proceso finalizado con éxito." >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

#!/bin/bash
# ======================================================================
# Script de Restauración: reset_lab.sh
# Objetivo: Eliminar mitigaciones y restaurar el firewall por defecto
# ======================================================================

echo "[+] Iniciando restauración del entorno de laboratorio..."

# 1. Limpiar (Flush) todas las reglas de iptables
sudo iptables -F

# 2. Borrar cualquier cadena personalizada
sudo iptables -X

# 3. Restablecer las políticas por defecto a ACCEPT para no bloquearnos
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

echo "[✔] ¡Laboratorio restaurado con éxito! El firewall está limpio."

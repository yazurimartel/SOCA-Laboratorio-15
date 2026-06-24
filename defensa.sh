#!/bin/bash
# ======================================================================
# Script de Defensa: defensa.sh
# Objetivo: Mitigar SYN Flood (L4) y Bloquear Descarga Pesada (L7)
# ======================================================================

echo "[+] Iniciando despliegue del Plan de Acción..."

# 1. Limpieza previa del firewall (Vaciado de reglas existentes)
echo "[+] Vaciando reglas previas de iptables..."
sudo iptables -F
sudo iptables -X

# 2. MITIGACIÓN CAPA 7: Filtrado de Cadenas (String Matching)
# Bloquea cualquier petición HTTP en el puerto 80 que contenga "db.sql"
echo "[+] Implementando filtro Capa 7 para el archivo pesado (db.sql)..."
sudo iptables -A INPUT -p tcp --dport 80 -m string --string "db.sql" --algo bm -j DROP

# 3. MITIGACIÓN CAPA 4: Rate Limiting contra SYN Flood
# Permite un máximo de 10 paquetes SYN por segundo, con un ráfaga (burst) inicial de 20.
echo "[+] Configurando Rate Limiting en Capa 4 para paquetes TCP SYN..."
sudo iptables -A INPUT -p tcp --syn --dport 80 -m limit --limit 10/s --limit-burst 20 -j ACCEPT
# El exceso de paquetes SYN que superen el límite establecido será descartado de inmediato
sudo iptables -A INPUT -p tcp --syn --dport 80 -j DROP

# 4. Permitir el resto del tráfico legítimo
# Asegura que las conexiones ya establecidas y el tráfico normal sigan funcionando
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

echo "[✔] ¡Defensa desplegada con éxito!"
echo "[+] Estado actual de las reglas en INPUT:"
sudo iptables -L INPUT -v -n

#!/bin/bash
# ======================================================================
# Script Monitor: monitor.sh
# Objetivo: Vigilar conexiones HTTP y disparar defensa si hay anomalías
# ======================================================================

# Definir el umbral máximo de conexiones permitidas
UMBRAL=100

# Contar cuántas conexiones TCP (ESTABLISHED o SYN-RECV) hay en el puerto 80
CONEXIONES=$(ss -ant | grep :80 | wc -l)

# Lógica de prevención
if [ "$CONEXIONES" -gt "$UMBRAL" ]; then
    echo "¡Alerta! Posible ataque detectado ($CONEXIONES conexiones activas)."
    
    # Ejecutar el script de defensa (Asegúrate de poner la ruta correcta)
    /home/alumno/defensa.sh
    
    # Registrar el evento en un archivo log para auditoría
    echo "$(date): Defensa activada. Conexiones: $CONEXIONES" >> /var/log/ataques_web.log
fi

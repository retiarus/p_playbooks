#!/bin/bash
PATH=/usr/bin

alert="Signature detected: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"

# Envia o alerta para o systemd logger se existir, do contrário para /var/log
if [[ -z $(command -v systemd-cat) ]]; then
        echo "$(date) - $alert" >> /var/log/clamav/detections.log
else
        # Isso poderia fazer com que seu DE mostre um alerta virtual. Acontece no plasma, mas o próximo alerta visual é muito melhor
        echo "$alert" | /usr/bin/systemd-cat -t clamav -p emerg
fi

# Envia um alerta para todos os usuários na interface gráfica.
XUSERS=($(who|awk '{print $1$NF}'|sort -u))

for XUSER in $XUSERS; do
    NAME=(${XUSER/(/ })
    DISPLAY=${NAME[1]/)/}
    DBUS_ADDRESS=unix:path=/run/user/$(id -u ${NAME[0]})/bus
    echo "run $NAME - $DISPLAY - $DBUS_ADDRESS -" >> /tmp/testlog
    /usr/bin/sudo -u ${NAME[0]} DISPLAY=${DISPLAY} \
                       DBUS_SESSION_BUS_ADDRESS=${DBUS_ADDRESS} \
                       PATH=${PATH} \
                       /usr/bin/notify-send -i dialog-warning "clamAV" "$alert"
done

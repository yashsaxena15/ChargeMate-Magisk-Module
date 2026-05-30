#!/system/bin/sh

# Wait until boot is fully complete
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 5
done

# Allow system to stabilize before starting
sleep 10

# Load user config
MODDIR="${0%/*}"
CONFIG="$MODDIR/config.sh"

if [ -f "$CONFIG" ]; then
    . "$CONFIG"
else
    # Default fallback values
    STOP=95
    START=85
fi

# Validate STOP value — must be between 50 and 99
if [ "$STOP" -lt 50 ] || [ "$STOP" -gt 99 ]; then
    STOP=95
fi

# Validate START value — must be at least 5% below STOP
if [ "$START" -ge "$STOP" ] || [ "$((STOP - START))" -lt 5 ]; then
    START=$((STOP - 10))
fi

STATE=""

while true; do
    level=$(cat /sys/class/power_supply/battery/capacity)
    online=$(cat /sys/class/power_supply/charger/online)
    usb_state=$(cat /sys/class/android_usb/android0/state)

    if [ "$online" = "1" ]; then

        # USB data connection active — skip charging control
        if [ "$usb_state" = "CONFIGURED" ]; then
            echo 0 > /sys/class/power_supply/battery/input_suspend
            STATE=""
            sleep 30
            continue
        fi

        # Pause charging at STOP%
        if [ "$level" -ge "$STOP" ] && [ "$STATE" != "PAUSED" ]; then
            echo 1 > /sys/class/power_supply/battery/input_suspend
            STATE="PAUSED"
        fi

        # Resume charging at START%
        if [ "$level" -le "$START" ] && [ "$STATE" != "RUNNING" ]; then
            echo 0 > /sys/class/power_supply/battery/input_suspend
            STATE="RUNNING"
        fi

    else
        # Charger disconnected or power cut — reset suspend and state
        echo 0 > /sys/class/power_supply/battery/input_suspend
        STATE=""
    fi

    sleep 30
done

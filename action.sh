#!/system/bin/sh

MODDIR=$(dirname "$0")

echo "================================================"
echo "          ChargeMate - Reload Config"
echo "================================================"

# Load new config
. "$MODDIR/config.sh"

# Validate STOP value
if [ "$STOP" -lt 50 ] || [ "$STOP" -gt 99 ]; then
    echo "ERROR: Invalid STOP value ($STOP). Must be 50-99."
    echo "Keeping old config."
    exit 1
fi

# Validate START value
if [ "$START" -ge "$STOP" ] || [ "$((STOP - START))" -lt 5 ]; then
    echo "ERROR: Invalid START value ($START)."
    echo "START must be at least 5% below STOP."
    exit 1
fi

echo "New config loaded:"
echo "  STOP  : $STOP%"
echo "  START : $START%"
echo "------------------------------------------------"

# Kill old service process
OLD_PID=$(pgrep -f "service.sh")
if [ -n "$OLD_PID" ]; then
    kill "$OLD_PID"
    echo "Old service stopped. (PID: $OLD_PID)"
fi

# Safety reset before restart
echo 0 > /sys/class/power_supply/battery/input_suspend

# Start new service in background
sh "$MODDIR/service.sh" &

echo "Service restarted successfully!"
echo "------------------------------------------------"

# Show current status
level=$(cat /sys/class/power_supply/battery/capacity)
suspend=$(cat /sys/class/power_supply/battery/input_suspend)
online=$(cat /sys/class/power_supply/charger/online)
usb_state=$(cat /sys/class/android_usb/android0/state)

echo "Battery  : $level%"

if [ "$online" = "1" ]; then
    echo "Charger  : Connected"
    echo "USB Mode : $usb_state"
    [ "$suspend" = "1" ] && echo "Status   : PAUSED" || echo "Status   : CHARGING"
else
    echo "Charger  : Disconnected"
    echo "Status   : IDLE"
fi

echo "================================================"

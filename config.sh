#!/system/bin/sh

# =============================================
#         ChargeMate - Configuration
# =============================================
# STOP  : Battery % at which charging will pause
# START : Battery % at which charging will resume
#
# Rules:
#   - STOP must be between 50 and 99
#   - START must be at least 5% less than STOP
#   - Recommended: STOP=95, START=85
#
# After editing, tap Action button in Magisk
# to apply changes instantly without reboot.
# =============================================

STOP=95
START=85

#!/system/bin/sh

# =============================================
#       Battery Charge Limit - Config
# =============================================
# Modify the values below to set your preferred
# charging limits.
#
# STOP  : Battery % at which charging will pause
# START : Battery % at which charging will resume
#
# Rules:
#   - STOP must be between 50 and 99
#   - START must be at least 5% less than STOP
#   - Recommended: STOP=95, START=85
# =============================================

STOP=95
START=85

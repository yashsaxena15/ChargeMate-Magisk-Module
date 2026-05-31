# 🔋 ChargeMate — Magisk Module

A lightweight Magisk module that automatically limits battery charging between configurable percentage levels, designed to extend long-term battery health. Supports instant config reload via the Action button — no reboot required.

---

## ✨ Features

- 🔋 Stops charging at a configurable **STOP%** (default: 95%)
- 🔄 Resumes charging at a configurable **START%** (default: 85%)
- ⚡ **Action button** — reload config instantly without reboot
- 🖥️ Automatically **bypasses charging control** during USB file transfer, MTP, PTP, or USB tethering
- 🔌 Handles **power cuts and charger reconnects** gracefully
- 📝 Simple **config file** — no app required
- 🪶 Zero UI, zero bloat — pure shell script

---

## 📱 Compatibility

| Device Type | Supported |
|---|---|
| MediaTek (MTK) devices | ✅ Yes |
| Redmi Note 9 / Note 8 / Helio G series | ✅ Tested |
| Snapdragon devices | ❌ No (`input_suspend` node not available) |
| Exynos (Samsung) devices | ❌ No |
| Android 8 – 12 | ✅ Yes |
| Android 13+ | ⚠️ Untested |

> **Tested on:** Redmi Note 9 (Merlin) — Android 10, MIUI 12, Kernel 4.14, Magisk

---

## 📦 Installation

1. Download the latest `ChargeMate_vX.X.zip` from [Releases](../../releases)
2. Open **Magisk** → Modules → **Install from storage**
3. Select the downloaded zip
4. **Reboot** your device

---

## ⚙️ Configuration

After installation, edit the config file at:

    /data/adb/modules/chargemate/config.sh

```sh
# Battery % at which charging will pause (50–99)
STOP=95

# Battery % at which charging will resume (must be at least 5% below STOP)
START=85
```

After editing, tap the **Action button** in Magisk to apply changes instantly — no reboot needed.

### Recommended Values

| Use Case | STOP | START |
|---|---|---|
| Daily driver (recommended) | 95 | 85 |
| Maximum battery health | 80 | 70 |
| Overnight charging | 90 | 80 |

---

## ▶️ Action Button

Tap the **Action** button in Magisk → Modules → ChargeMate to:

- Reload `config.sh` values instantly
- Restart the background service with new limits
- View current battery status, charger state, and active config

No reboot required after config changes.

---

## 🔍 How It Works

```
Charger connected
        ↓
Is USB data / tethering active?
    YES → Skip control, charging continues normally
    NO  ↓
Level >= STOP%  → Pause charging   (input_suspend = 1)
Level <= START% → Resume charging  (input_suspend = 0)

Charger disconnected / power cut
    → Reset input_suspend = 0  (safety reset)
    → Fresh state on reconnect
```

---

## 📂 Module Structure

```
chargemate/
├── module.prop          # Module metadata
├── service.sh           # Background service (auto-starts on boot)
├── config.sh            # User configuration — edit this file
├── action.sh            # Action button script (instant config reload)
└── META-INF/
    └── com/google/android/
        ├── update-binary
        └── updater-script
```

---

## ❓ FAQ

**Q: Charging stopped permanently. How do I fix it?**

Disable the module from Magisk → Modules → ChargeMate, then reboot.

**Q: Will USB file transfer still work?**

Yes. The module monitors the USB state. Whenever a data connection is detected (MTP, PTP, tethering), charging control is automatically bypassed.

**Q: Do I need to reboot after editing config.sh?**

No. Just tap the **Action button** in Magisk to reload the config instantly.

**Q: How do I verify the script is running?**

```sh
cat /sys/class/power_supply/battery/input_suspend
# Output: 1 = charging paused | 0 = charging active
```

---

## 📜 Changelog

**v3.0**
- Added Action button support for instant config reload without reboot
- Added config validation with error messages
- Added real-time status display in Action output

**v2.0**
- Added configurable STOP and START values via config.sh
- Added USB data connection detection (MTP, PTP, tethering bypass)
- Added charger disconnect safety reset

**v1.0**
- Initial release with fixed 95/85% charging limits

---

## 📜 License

MIT License — free to use, modify, and distribute.

---

## 🙏 Credits

- [Magisk](https://github.com/topjohnwu/Magisk) by topjohnwu
- Developed and tested on Redmi Note 9 by **Yash**

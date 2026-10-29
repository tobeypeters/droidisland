# DroidIsland

A dynamic-island style status bar for Android, drawn as an overlay above the system status bar. It mimics the iOS "Dynamic Island" but adapts to whatever Android lets a third-party app do: it hosts a compact pill at the top of the screen, shows live status (clock, battery, network, signal icons, media, timers), and expands into a notification / media / quick-tools / battery panel.

Built with Kotlin, no Jetpack Compose, no external UI libraries. Single Activity, single foreground Service, one optional AccessibilityService for trusted window overlays.

---

## Features

- **Collapsed pill** in the status bar strip, above the system bar, that shows:
  - Clock and date (configurable format)
  - Battery percentage and a dynamically-drawn battery icon
  - Wi-Fi signal-level icon (0 to 4 arcs) when connected to Wi-Fi
  - Mobile network type (`5G`, `LTE`, `3G`, `2G`, or `Cell`) when on cellular
  - Status icons: airplane mode, Do Not Disturb, silent, vibrate, alarm, location, VPN, Bluetooth, battery saver
  - Live network down-speed
  - Notification icons for pending notifications
- **Expanded island** with multiple pages:
  - **Notifications** — app name, title, body, plus **Mute** and **Dismiss** buttons
  - **Media** — album art, title, artist, and play/pause/skip controls
  - **Timer** — stopwatch with start/pause/reset
  - **Quick tools** — flashlight, internet panel, Bluetooth settings, DroidIsland settings
  - **Battery** — percentage, charging state
- **Gestures**
  - Tap the pill to expand
  - Swipe left/right to change page
  - Swipe up to collapse or dismiss a notification
  - Tap a notification to open its app
  - Long-press a notification to mute that app
  - Long-press the pill to open the settings app
- **Optional full-width "bar cover"** drawn behind the pill to hide HUD chips (screen recording, USB connection, drag targets) from the top strip
- **Raised-button bevel** around the pill (drawn only when the bar cover is off)
- **Nine preset colors, black/white/grey, and three colors sampled from the current wallpaper**
- **"Hide in apps" list** to make the island disappear when a chosen app is in front
- **Hidden on the lock screen**
- **"Hide system icons" integration** via `icon_blacklist`, so the real status bar's clock, battery, and signal icons don't duplicate the island's
- **Auto-start on boot** (optional)

---

## Requirements

- Android 12 or newer (works from Android 8, but overlay reliability is much better from 12)
- The app needs to be given a few permissions that Android does not allow normal apps to grant themselves. All of them are covered below.

| Permission | Why |
|---|---|
| **Draw over other apps** (`SYSTEM_ALERT_WINDOW`) | Required to display any overlay window |
| **Notification access** | Required to read notifications and media metadata |
| **Accessibility service** | Required for `TYPE_ACCESSIBILITY_OVERLAY` windows, which are the only overlays the Android 12+ untrusted-touch filter allows to receive reliable touches |
| **Phone state** (`READ_PHONE_STATE`) | Required to read `dataNetworkType` for the `5G`/`LTE`/`3G`/`2G` label |
| **Fine location** (`ACCESS_FINE_LOCATION`) | Required on Android 10+ for `WifiManager.connectionInfo.rssi` to be non-redacted |
| **`WRITE_SECURE_SETTINGS`** | Optional. Needed only for the "Hide system icons" feature (`icon_blacklist`). Must be granted via ADB |
| **Usage access** | Optional. Needed only for the "Hide in apps" feature |

---

## Downloading a release

If a release `.apk` is published:

1. Go to the [Releases](../../releases) page.
2. Download the latest `droidisland.apk`.
3. Follow the **Install** section below.

---

## Install

### Android (manual)

1. Copy the APK to the phone.
2. Open it in your file manager. Allow "Install unknown apps" for the file manager when prompted.
3. Tap install.
4. Launch **DroidIsland**. The setup screen shows every required permission with a status badge and a **Grant** button. Grant them all, then tap **Start island**.

### Windows (ADB install)

1. Download and install [Android Platform Tools](https://developer.android.com/tools/releases/platform-tools) (the ZIP contains `adb.exe`).
2. Enable **Developer options** on the phone:
   - Settings → About phone → tap **Build number** seven times.
3. Enable **USB debugging**:
   - Settings → System → Developer options → **USB debugging** → On.
4. Plug the phone into the PC with a USB data cable.
5. On the phone, accept the **Allow USB debugging?** prompt. Check "Always allow from this computer".
6. Open a Command Prompt or PowerShell in the platform-tools folder:
   ```powershell
   cd "%LOCALAPPDATA%\Android\Sdk\platform-tools"
   ```
- **Screenshots**
<img src="(docs/ui1.png" alt="drawing" width="25%" height="25%" />

## ⚠️ Required ADB command

DroidIsland needs one permission that Android does not allow normal apps to grant themselves: **`WRITE_SECURE_SETTINGS`**. This is required for the "Hide system icons" feature, which is the whole point of the app — replacing the real status bar with the island.

After install:
Open a terminal with `adb` available (see [Install](#install) for setup) and run:

```bash
adb shell pm grant com.example.island android.permission.WRITE_SECURE_SETTINGS
```

After Uninstall:
Open a terminal with `adb` available (see [Install](#install) for setup) and run:

```bash
adb shell pm revoke com.example.island android.permission.WRITE_SECURE_SETTINGS
```

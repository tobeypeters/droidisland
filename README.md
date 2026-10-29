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

### Installing ADB

ADB (Android Debug Bridge) is needed to install the APK from a computer and, more importantly, to grant the [required `WRITE_SECURE_SETTINGS` permission](#️-required-adb-command). Pick your operating system below.

#### Windows

1. Download the **SDK Platform-Tools for Windows** ZIP from the [official download page](https://developer.android.com/tools/releases/platform-tools).
2. Extract the ZIP, for example to `C:\platform-tools`. The folder contains `adb.exe`.
3. *(Optional but recommended)* Add the folder to your `PATH` so you can run `adb` from anywhere:
   - Press **Win**, search for **Edit the system environment variables**, and open it.
   - Click **Environment Variables…**, select **Path** under *User variables*, and click **Edit**.
   - Click **New**, enter `C:\platform-tools`, and confirm with **OK**.
   - Close and reopen any Command Prompt / PowerShell windows.
4. Verify the install:
   ```powershell
   adb version
   ```
   If you skipped step 3, open PowerShell in the extracted folder and run `.\adb version` instead.

> **Tip:** If you have Android Studio installed, `adb.exe` is already at `%LOCALAPPDATA%\Android\Sdk\platform-tools` (PowerShell: `$env:LOCALAPPDATA\Android\Sdk\platform-tools`).

#### Linux

**Option A: package manager (easiest)**

```bash
# Debian / Ubuntu / Linux Mint
sudo apt update && sudo apt install adb

# Fedora
sudo dnf install android-tools

# Arch / Manjaro
sudo pacman -S android-tools

# openSUSE
sudo zypper install android-tools
```

**Option B: official Platform-Tools ZIP (always the latest version)**

```bash
cd ~
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
unzip platform-tools-latest-linux.zip
echo 'export PATH="$HOME/platform-tools:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

If you use zsh, replace `~/.bashrc` with `~/.zshrc`.

Verify the install:

```bash
adb version
```

### Preparing the phone for ADB

1. Enable **Developer options**: Settings → About phone → tap **Build number** seven times.
2. Enable **USB debugging**: Settings → System → Developer options → **USB debugging** → On.
3. Plug the phone into the computer with a USB **data** cable (some cables are charge-only).
4. On the phone, accept the **Allow USB debugging?** prompt and check **Always allow from this computer**.
5. Confirm the phone is detected:
   ```bash
   adb devices
   ```
   The phone should be listed with the status `device`. If it says `unauthorized`, re-check the prompt on the phone. If the list is empty, try another cable or USB port.

### Installing the APK with ADB

Windows (PowerShell / Command Prompt) and Linux use the same command. Replace the path with the location of your APK:

```bash
adb install droidisland.apk
```

To update an existing installation and keep its settings, add `-r`:

```bash
adb install -r droidisland.apk
```

Then launch **DroidIsland** on the phone and continue with the setup screen. Don't forget the [required ADB command](#️-required-adb-command) below.

### Troubleshooting ADB

| Problem | Fix |
|---|---|
| `adb: command not found` / `'adb' is not recognized` | The Platform-Tools folder is not on your `PATH`. Add it (see above) or run the binary by its full path. |
| `adb devices` shows nothing (Windows) | Install your phone manufacturer's USB driver, or the [Google USB driver](https://developer.android.com/studio/run/win-usb). |
| `no permissions` or `insufficient permissions` (Linux) | Your user lacks USB access. Install udev rules (`sudo apt install android-sdk-platform-tools-common` on Debian/Ubuntu) and replug the phone. Or run `adb kill-server && sudo adb start-server` as a quick test. |
| Device shows as `unauthorized` | Unlock the phone and accept the **Allow USB debugging?** prompt. If it doesn't appear, revoke USB debugging authorizations in Developer options and reconnect. |
| Device shows as `offline` | Run `adb kill-server`, unplug and replug the cable, then run `adb devices` again. |
| `INSTALL_FAILED_UPDATE_INCOMPATIBLE` | The installed copy was signed with a different key. Uninstall it first, then install again. |

---

- **Screenshots**
<br><img src="docs/ui1.png" alt="UI" width="15%" height="15%" />&nbsp; &nbsp;&nbsp;&nbsp;<img src="docs/ui2.png" alt="UI" width="15%" height="15%" />

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

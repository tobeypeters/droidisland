
A few notes on the file:

- **Project name and package** — I used `com.example.island` because that's what your manifest uses. If you rename the package before publishing, update every `adb shell pm grant` line and the `am start` component. The README flags this at the top of the ADB section.
- **License** — I left a placeholder line. Pick whichever you prefer (MIT and Apache-2.0 are the usual choices for Android apps) and replace the line.
- **Screenshots** — add them under the Features section if you want. A one-line `![Collapsed](docs/collapsed.png)` with an image in `docs/` is enough.
- **Releases link** — the `../../releases` link assumes the README is at the repo root; that's correct for GitHub.

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

# Testing Guide

This guide explains how to check the Godot prototype locally and on Android. The project is still a prototype; run these checks after pulling the latest changes and before sharing a build.

## Requirements

- Godot 4.3 or later (use the same version for editing, running, and exporting).
- Git, if cloning the repository.
- For Android testing: Android export templates matching your Godot version, Android SDK, a compatible JDK, and an Android device or emulator.

## 1. Get the project

Clone the repository, or download it from GitHub:

```bash
git clone https://github.com/Muhdrabe22/lamamagame.git
cd lamamagame
```

Open `project.godot` in Godot Project Manager using **Import**. Wait for the editor to scan/import the project, then inspect the Output and Debugger panels for errors.

## 2. Run the desktop smoke test

Press **F5** in Godot to run the project. Verify:

- The main menu appears and chapter and armory screens open.
- Urban Strike is available at the start; later missions are locked until unlocked.
- The player moves with the on-screen arrows and keyboard arrow keys.
- The player can aim and fire; ammo decreases and reload restores it.
- Enemies can be hit and defeated; the kill objective updates.
- Enemies patrol, detect/chase the player, and can damage the player.
- Winning or losing displays the result screen; retry and return-to-menu controls work.
- Weapon selection changes the weapon's gameplay stats.
- Progress survives closing and reopening the game.

Also run the missions sequentially to check that winning a mission unlocks the next chapter. The Scout weapon should unlock after three total kills, and Heavy after two wins.

## 3. Check project scripts from the command line (optional)

Run the Godot editor in headless mode to catch project parsing/import errors. Adjust the executable name or path for your system:

```bash
godot --headless --path . --editor --quit
```

A successful editor scan is useful but does not replace playing through the game in the editor or on a device.

## 4. Test on Android

1. Install export templates matching the installed Godot version.
2. Install Android Studio/SDK components and a JDK version supported by that Godot release.
3. Set the SDK and Java paths in **Editor → Editor Settings → Export → Android**.
4. Open **Project → Export** and review the Android preset. Do not commit signing keys, passwords, or machine-specific SDK paths.
5. Enable Developer options and USB debugging on the Android device, connect it, and approve the computer authorization prompt.
6. Export a debug APK, install it, and launch the app. Alternatively, use Godot's device deploy option.

Example install commands, if Android Debug Bridge (`adb`) is installed:

```bash
adb devices
adb install -r build/android/sniper_elite.apk
adb logcat
```

The repository's Android export preset is only a starting configuration. Confirm the export path and current Play requirements in Godot and Google Play Console; no APK or physical-device test is produced by this guide.

## 5. Android device checklist

- [ ] App installs and opens without a crash.
- [ ] Portrait layout remains readable on the target screen and respects system safe areas.
- [ ] Touch movement, aiming, firing, and reload controls respond reliably.
- [ ] Health, ammo, objective, and mission result UI update correctly.
- [ ] Sound effects play at sensible volume and the game remains usable when muted.
- [ ] Chapter and weapon unlocks persist after closing and reopening the app.
- [ ] App behaves correctly when sent to the background and resumed.
- [ ] Performance is acceptable during a complete mission; check logs for errors.

## 6. Save-data and reset notes

The game stores progress under Godot's `user://` data directory as `sniper_elite_save.cfg`. To test a fresh profile, remove that save file from the test device's app data or add/use a development-only reset action. Do not add a progress-reset control to a release build unless intended.

## 7. Report a test issue

When reporting a problem, include:

- Godot version and operating system/device model.
- Steps to reproduce and expected versus actual behavior.
- The first relevant error from Godot's Debugger or Android `adb logcat`.
- Whether it happens on desktop, emulator, or physical device.

Never include signing credentials, private keys, or personal information in logs or screenshots.

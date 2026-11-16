# Android device testing checklist

This project includes an unsigned Android export preset. Android SDK/Java paths and signing credentials are intentionally not committed; configure them locally in Godot.

## Local setup

1. Install Godot 4.3+ and the matching export templates from **Editor → Manage Export Templates**.
2. Install Android Studio, Android SDK Platform Tools, Android SDK Build Tools, and a supported JDK (Godot 4 Android export setup currently recommends JDK 17; verify against the exact engine version).
3. In Godot, configure the Android SDK path and Java SDK path under **Editor → Editor Settings → Export → Android**.
4. Open **Project → Export**, select the Android preset, and verify package identifier `com.muhdrabe.sniperelite`, target SDK, and device architecture.
5. For a signed release, create a keystore locally and enter its values in the export preset UI or a local, untracked preset. Never commit keystore files or passwords.

## Export and install

- Export a debug APK to `build/android/sniper_elite.apk`.
- Connect an Android phone with developer options and USB debugging enabled, approve the computer prompt, then install from Godot's run/deploy action or Android Debug Bridge (`adb install -r build/android/sniper_elite.apk`).
- Check the Android device log (`adb logcat`) and Godot debugger output for startup, script, and rendering errors.

## Test on device

- Portrait orientation and safe-area layout on different screen sizes.
- Touch movement buttons, aim/tap firing, reload, ammo/health HUD, hit/death state.
- Main menu, mission unlock sequence, retry/menu/next mission buttons.
- Weapon selection and damage/ammo differences; kill counts and unlocks persist after force-closing and reopening.
- Performance, audio levels, resume after app backgrounding, and behavior with audio muted.

This repository cannot run a physical Android device test from GitHub. Complete this checklist on a real device before release; the preset is configuration, not a verified APK.

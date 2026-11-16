# SNIPER ELITE

A mobile-first Godot 4 Android prototype with a menu, three chapter missions, weapon unlocks, and local progression saves.

## Run

1. Open `project.godot` in Godot 4.3+.
2. Press **F5** for the main menu.
3. Choose **Chapter Select** to start Urban Strike. Winning unlocks Desert Watch, then Jungle Run.
4. Visit the **Weapon Armory** to equip unlocked weapons. Scout unlocks at 3 total kills; Heavy unlocks after 2 mission wins.

## Progression

Progress is stored locally in `user://sniper_elite_save.cfg`. It records wins, total/best kills, best winning time, completed and unlocked missions, and unlocked weapons. To reset progress, call `SaveManager.reset_progress()` from a debug action or delete the save file from the platform's user data folder.

## Android

An unsigned Android export preset is included. Configure export templates, Android SDK, and Java paths in the Godot editor, then export/install on a USB-debugging-enabled device. See [ANDROID_TESTING.md](ANDROID_TESTING.md) for setup and a physical-device checklist. Signing credentials are intentionally excluded. No physical device test or APK build was performed in this repository environment.

## Current prototype content

The three missions use placeholder polygon art and share the same core gameplay loop. Audio effects are synthesized at runtime. Replace placeholder geometry and tune balance before release.

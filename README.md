# SNIPER ELITE

A mobile-first arcade target-practice prototype for Android, built with Godot 4.

## Step 1: Run the first playable build

The project currently contains a simple playable loop: tap **Start**, hit the targets before the 30-second timer runs out, and try to beat your score. Tapping the arena away from the target counts as a miss. The UI is designed for portrait touch screens and also works with a mouse in the editor.

### Run in Godot

1. Install Godot 4.3 or later.
2. Clone or download this repository.
3. In Godot Project Manager, choose **Import** and select this repository's `project.godot`.
4. Open the project and press **F6** to run the main scene, or **F5** to run the project.

## Step 2: Build and test on Android

1. Install the Android export templates from Godot's **Editor > Manage Export Templates** menu.
2. Install the Android SDK and configure its paths in **Editor > Editor Settings > Export > Android**.
3. In **Project > Export**, add an Android preset and set the package name to a unique reverse-domain identifier, such as `com.example.sniperelite`.
4. Connect an Android device with USB debugging enabled, or use an emulator, then deploy the project from Godot.

## Project layout

- `assets/` — art, audio, materials, and textures
- `scenes/` — reusable Godot scenes
- `scripts/` — GDScript logic
- `levels/` — chapter and mission content
- `data/` — gameplay tuning data
- `resources/` — shared Godot resources
- `tests/` — future automated gameplay tests

## Next development steps

1. Add a mission scene with a themed background and objective.
2. Replace the placeholder target with animated targets and add hit feedback/audio.
3. Add difficulty progression and persistent high scores.
4. Add Android export presets and test performance on a real device.

# SNIPER ELITE

A mobile-first Godot 4 prototype targeting Android.

## Run the mission

1. Open `project.godot` in Godot 4.3 or later.
2. Press **F5** to launch the project.
3. Use the on-screen arrows to move, tap the arena to aim/fire, or use **FIRE**. Use **RELOAD** to refill the magazine.
4. Enemies patrol, chase, and attack when close. Eliminate all three to win; if player health reaches zero, the mission fails.
5. The result screen lets you restart. Progress is saved locally in `user://sniper_elite_save.cfg` and includes wins, total kills, best kills, and fastest winning time.

## Feedback and polish

- Shooting, hit, reload, player damage, enemy defeat, and mission result sounds are synthesized at runtime; no external audio files are required.
- Hit flashes, a brief shot tracer, and an enemy defeat particle burst provide basic combat feedback.
- Art remains placeholder geometry and should be replaced with original game assets before release.

## Main scene tree

```text
Main
└── UrbanMission
    ├── Player
    ├── EnemyA / EnemyB / EnemyC
    ├── MissionController
    └── HUD
```

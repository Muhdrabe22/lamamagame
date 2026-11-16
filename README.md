# SNIPER ELITE

A mobile-first Godot 4 prototype targeting Android.

## Run the mission

1. Open `project.godot` in Godot 4.3 or later.
2. Press **F5** to launch the project.
3. Use the on-screen arrows to move, tap the arena to aim/fire, or use **FIRE**. Use **RELOAD** to refill the magazine.
4. Enemies patrol nearby, chase the player when spotted, and attack at close range. Eliminate all three to win; if player health reaches zero, the mission fails.
5. Use **RESTART MISSION** on the result screen to play again.

The visuals are placeholder geometry. Enemy patrol movement, chase, and attacks are basic prototype behaviors intended for tuning.

## Main scene tree

```text
Main
└── UrbanMission
    ├── Player
    ├── EnemyA / EnemyB / EnemyC
    ├── MissionController
    └── HUD
```

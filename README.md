# SNIPER ELITE

A mobile-first Godot 4 prototype targeting Android.

## Run the mission

1. Open `project.godot` in Godot 4.3 or later.
2. Press **F6** to run `scenes/main/Main.tscn`, or **F5** to launch the project.
3. Use the on-screen arrows to move, tap the arena to aim/fire, or use the FIRE button. Use RELOAD when needed.
4. Eliminate all three red targets to complete the mission. The current build uses simple placeholder shapes.

## Scene tree

```text
Main (Node2D)
└── UrbanMission (instance)
    ├── Background / Road / RoadMarkings (Polygon2D)
    ├── Player (CharacterBody2D)
    │   ├── Body (Polygon2D)
    │   ├── CollisionShape2D
    │   └── Weapon (instance)
    │       ├── Barrel (Polygon2D)
    │       └── Muzzle (Polygon2D)
    ├── EnemyA / EnemyB / EnemyC (Area2D instances)
    │   ├── Body and CenterMark (Polygon2D)
    │   └── CollisionShape2D
    ├── MissionController (Node)
    └── HUD (CanvasLayer instance)
```

## Controls

- On-screen arrow buttons: move the player.
- Tap/click the arena: aim and fire.
- FIRE: shoot in the current aim direction.
- RELOAD: refill the magazine.
- Desktop: arrow keys move; left-click aims and fires.

The art is placeholder geometry. Add proper animations, sound, original assets, and Android export settings after validating the core loop on a device.

# Technical Architecture

## Engine
Godot 4

## Core Responsibilities
- Player movement and aiming
- Weapon system
- Enemy AI and state machine
- Mission progression manager
- Save and load controller
- UI and HUD
- Audio and FX system

## Key Modules
- Player module for movement, health, and combat
- Weapons module for firing, recoil, and ammo
- Enemies module for detection, patrol, and damage states
- Missions module for objectives, triggers, and rewards
- Managers module for flow, state, and game loop orchestration

## Recommended Design Patterns
- component-driven scene composition
- singleton managers for core subsystems
- data-driven balance files under data/
- event-driven mission triggers

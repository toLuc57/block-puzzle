<!--
  Sync Impact Report:
  - Version change: [PROJECT_NAME] Constitution v1.0.0 (Initial)
  - List of modified principles:
    - [PRINCIPLE_1_NAME] -> I. Modern & Responsive Visuals
    - [PRINCIPLE_2_NAME] -> II. Signal-Driven Architecture
    - [PRINCIPLE_3_NAME] -> III. Resource-Based Data Management
    - [PRINCIPLE_4_NAME] -> IV. Empirical Validation & Testing
    - [PRINCIPLE_5_NAME] -> V. Performance-First Grid Logic
  - Added sections: Technical Constraints, Iterative Development Workflow
  - Removed sections: None
  - Templates requiring updates: 
    - ✅ .specify/templates/plan-template.md (updated)
    - ✅ .specify/templates/tasks-template.md (updated)
    - ✅ .specify/templates/spec-template.md (reviewed, no changes needed)
  - Follow-up TODOs: None
-->

# block-puzzle Constitution

## Core Principles

### I. Modern & Responsive Visuals
The game must feel modern, clean, and "alive." Every mechanic should have polished visual feedback, including "ghost" blocks for placement and satisfying animations for line clears. Interactions should be responsive, with blocks scaling when grabbed and snapping satisfyingly into the 10x10 grid.

### II. Signal-Driven Architecture
Use Godot's signal system to decouple game components. Systems like `Grid`, `BlockSpawner`, and `UIManager` must communicate via signals (e.g., `BlockPlaced`, `LineCleared`, `GameOver`) to ensure modularity and maintainability.

### III. Resource-Based Data Management
Block shapes, colors, and properties must be defined using Godot `Resource` files. This allows for easy extensibility of block types (polyominoes and larger irregular shapes) without modifying core spawning logic.

### IV. Empirical Validation & Testing
Every core mechanic (grid occupancy, line clearing, game over detection) must be verified through automated tests or dedicated manual debug scripts before being considered complete. Bug fixes must be preceded by a reproduction case.

### V. Performance-First Grid Logic
Maintain a consistent 60 FPS by optimizing grid operations. Only check the affected rows and columns after a block placement. Use efficient data structures (2D arrays or flat arrays with mapping) for the 10x10 play area.

## Technical Constraints
- **Engine:** Godot Engine 4.6.
- **Language:** GDScript (following official style guides).
- **Platform:** Target desktop first, with mobile-friendly input (drag-and-drop).
- **Grid:** Fixed 10x10 play area.

## Iterative Development Workflow
Implementation must follow a surgical, iterative approach:
1. Grid Logic & Visuals.
2. Spawning System (3-block sets).
3. Drag & Drop Input.
4. Line Clearing Mechanics.
5. Scoring & Game Over conditions.

## Governance
- This Constitution supersedes all other development practices in this repository.
- All feature implementations must align with these principles.
- Amendments require a version bump and updated documentation.
- Use `GEMINI.md` for project-wide architecture and workflow guidance.

**Version**: 1.0.0 | **Ratified**: 2026-06-16 | **Last Amended**: 2026-06-16

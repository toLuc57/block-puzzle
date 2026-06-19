<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan:
[specs/002-ui-hud-polish/plan.md](specs/002-ui-hud-polish/plan.md)
(Written in Vietnamese)

## UI Architecture: VBoxContainer Layout

The main UI uses a 3-section VBoxContainer layout in [Main.tscn](scenes/main/Main.tscn):
- **TopPanel** (PanelContainer, 80px fixed height, SIZE_SHRINK_BEGIN): Contains HUD with Moves, Target, Progress, and buttons
- **GamePanel** (PanelContainer, SIZE_EXPAND_FILL): Contains SubViewportContainer with the 10x10 game grid, isolated from UI overlay
- **BottomPanel** (PanelContainer, 80px fixed height, SIZE_SHRINK_END): Contains BlockLegend showing block types and descriptions
- **VictoryLayer** (CanvasLayer, layer=10): Separate layer for Victory Popup, always on top

This layout ensures the game area (10x10 grid) never overlaps with UI elements, and responds correctly to window resizing.
<!-- SPECKIT END -->

extends Node2D

@export var data: BlockData

var grid_pos: Vector2i = Vector2i.ZERO
var is_moving: bool = false
var grid_logic: GridLogic

func _ready():
	if data:
		$Sprite2D.modulate = data.color

func push(direction: Vector2i) -> bool:
	if is_moving or not grid_logic:
		return false

	var target_pos = grid_pos
	if data.is_sliding:
		while true:
			var next_pos = target_pos + direction
			if not grid_logic.can_block_enter(next_pos):
				break
			target_pos = next_pos
	else:
		var next_pos = grid_pos + direction
		if grid_logic.can_block_enter(next_pos):
			target_pos = next_pos

	if target_pos == grid_pos:
		return false

	move_to(target_pos)
	return true

func move_to(target_grid_pos: Vector2i):
	is_moving = true
	var old_pos = grid_pos
	var target_world_pos = Vector2(target_grid_pos) * GameEvents.cell_size

	grid_logic.move_block(old_pos, target_grid_pos)

	var tween = create_tween()
	tween.tween_property(self, "position", target_world_pos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		grid_pos = target_grid_pos
		is_moving = false
		if grid_logic.is_target(grid_pos):
			$Sprite2D.modulate = Color.GREEN
		else:
			$Sprite2D.modulate = data.color
		GameEvents.block_moved.emit(self, old_pos, grid_pos)
		if grid_logic.check_win():
			GameEvents.win_condition_met.emit()
	)

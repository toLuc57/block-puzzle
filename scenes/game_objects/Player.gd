extends Node2D

var grid_pos: Vector2i = Vector2i.ZERO
var is_moving: bool = false
var grid_logic: GridLogic

func _input(event):
	if is_moving:
		return

	var dir = Vector2i.ZERO
	if event.is_action_pressed("up"):
		dir = Vector2i.UP
	elif event.is_action_pressed("down"):
		dir = Vector2i.DOWN
	elif event.is_action_pressed("left"):
		dir = Vector2i.LEFT
	elif event.is_action_pressed("right"):
		dir = Vector2i.RIGHT

	if dir != Vector2i.ZERO:
		attempt_move(dir)

func attempt_move(dir: Vector2i):
	if not grid_logic:
		printerr("Player: grid_logic is null. Movement aborted.")
		return

	var target_pos = grid_pos + dir
	if grid_logic.is_occupied(target_pos):
		var block = grid_logic.blocks[target_pos]
		if block.push(dir):
			move_to(target_pos)
		return

	if not grid_logic.can_player_enter(target_pos):
		return

	move_to(target_pos)

func move_to(target_grid_pos: Vector2i):
	is_moving = true
	var from_pos = grid_pos
	var target_world_pos = Vector2(target_grid_pos) * GameEvents.cell_size

	var tween = create_tween()
	tween.tween_property(self, "position", target_world_pos, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		grid_pos = target_grid_pos
		grid_logic.player_pos = target_grid_pos
		is_moving = false
		GameEvents.player_moved.emit(from_pos, grid_pos)
	)

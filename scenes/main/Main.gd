extends Control

const FLOOR_TERRAIN_SET := 0
const FLOOR_TERRAIN := 0
const BOUNDARY_SOURCE := 2
const BOUNDARY_ATLAS := Vector2i(6, 1)
const OBSTACLE_SOURCE := 2
const OBSTACLE_ATLAS := Vector2i(8, 1)
const TARGET_SOURCE := 1
const TARGET_ATLAS := Vector2i(0, 0)

@onready var grid_container = %GridContainer
@onready var target_layer = %TargetLayer
@onready var victory_layer = %VictoryLayer

var grid_logic: GridLogic
var level_gen: LevelGenerator

var player_scene = preload("res://scenes/game_objects/Player.tscn")
var block_scene = preload("res://scenes/game_objects/Block.tscn")
var gray_block_res = preload("res://resources/blocks/gray_block.tres")
var ice_block_res = preload("res://resources/blocks/ice_block.tres")

func _ready():
	grid_logic = GridLogic.new(12, 10)
	level_gen = LevelGenerator.new()
	level_gen.grid_logic = grid_logic

	GameEvents.block_moved.connect(_on_block_moved)
	GameEvents.next_level_requested.connect(_on_next_level_requested)
	GameEvents.reset_requested.connect(_on_reset_requested)
	GameEvents.win_condition_met.connect(_on_win)

	_generate_and_setup()

func _input(event):
	if event.is_action_pressed("ui_undo") or (event is InputEventKey and event.keycode == KEY_Z and event.ctrl_pressed):
		GameEvents.undo_requested.emit()
	elif event.is_action_pressed("ui_redo") or (event is InputEventKey and event.keycode == KEY_R):
		GameEvents.reset_requested.emit()

func _generate_and_setup():
	victory_layer.hide()
	var steps = 15
	var level_state = level_gen.generate_level(3, steps)
	level_state["target_moves"] = steps
	_setup_level(level_state)
	_update_progress()
	GameEvents.score_updated.emit(0, steps)

func _setup_level(state: Dictionary):
	for child in grid_container.get_children():
		child.queue_free()

	grid_logic = GridLogic.new(state.grid_size.x, state.grid_size.y)
	level_gen.grid_logic = grid_logic
	grid_logic.targets = state.targets.duplicate()

	target_layer.clear()
	_render_static_tiles(state)

	for boundary_pos in state.playable_mask.boundary_cells:
		grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)
	for obstacle_pos in state.obstacles:
		grid_logic.set_cell(obstacle_pos, GridLogic.CellType.OBSTACLE)
	for target_pos in state.targets:
		target_layer.set_cell(target_pos, TARGET_SOURCE, TARGET_ATLAS)

	for b_data in state.blocks:
		var block = block_scene.instantiate()
		block.grid_logic = grid_logic
		block.grid_pos = b_data.pos
		block.position = Vector2(b_data.pos) * GameEvents.cell_size
		block.data = gray_block_res if b_data.type == "gray-block" else ice_block_res
		grid_logic.blocks[b_data.pos] = block
		grid_container.add_child(block)

	var player = player_scene.instantiate()
	player.grid_logic = grid_logic
	player.grid_pos = state.player_pos
	player.position = Vector2(state.player_pos) * GameEvents.cell_size
	grid_logic.player_pos = state.player_pos
	grid_container.add_child(player)

	GameState.record_initial_state(player, grid_logic)

func _render_static_tiles(state: Dictionary):
	var floor_cells = []
	for x in range(state.grid_size.x):
		for y in range(state.grid_size.y):
			floor_cells.append(Vector2i(x, y))
	target_layer.set_cells_terrain_connect(floor_cells, FLOOR_TERRAIN_SET, FLOOR_TERRAIN)

	for boundary_pos in state.playable_mask.boundary_cells:
		target_layer.set_cell(boundary_pos, BOUNDARY_SOURCE, BOUNDARY_ATLAS)
	for obstacle_pos in state.obstacles:
		target_layer.set_cell(obstacle_pos, OBSTACLE_SOURCE, OBSTACLE_ATLAS)

func _on_block_moved(_block, _from, _to):
	_update_progress()

func _update_progress():
	var placed = 0
	for target_pos in grid_logic.targets:
		if grid_logic.is_occupied(target_pos):
			placed += 1
	GameEvents.progress_updated.emit(placed, grid_logic.targets.size())

func _on_next_level_requested():
	_generate_and_setup()

func _on_reset_requested():
	_generate_and_setup()

func _on_win():
	victory_layer.show()
	%VictoryPopup.show()

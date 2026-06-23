extends Control

const WATER_SOURCE := 7
const GRASS_SOURCE := 0
const PATH_TERRAIN_SET := 1
const PATH_TERRAIN := 1
const CROPS_SOURCE := 4
const CROPS_VARIANTS := [
	Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0),
	Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1)
]
const TARGET_SOURCE := 1
const TARGET_ATLAS := Vector2i(0, 0)

@onready var camera = %Camera2D
@onready var grid_container = %GridContainer
@onready var water_layer = %Water
@onready var grass_layer = %Grass
@onready var path_layer = %Path
@onready var crops_layer = %Crops
@onready var target_layer = %TargetLayer
@onready var victory_layer = %VictoryLayer

var grid_logic: GridLogic
var level_gen: LevelGenerator

var player_scene = preload("res://scenes/game_objects/Player.tscn")
var block_scene = preload("res://scenes/game_objects/Block.tscn")
var gray_block_res = preload("res://resources/blocks/gray_block.tres")
var ice_block_res = preload("res://resources/blocks/ice_block.tres")

func _ready():
	grid_logic = GridLogic.new(16, 14)
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

	for water_pos in state.water_cells:
		grid_logic.set_cell(water_pos, GridLogic.CellType.WATER)
	for grass_pos in state.grass_cells:
		grid_logic.set_cell(grass_pos, GridLogic.CellType.FLOOR)
	for boundary_pos in state.path_boundary_cells:
		grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)
	for obstacle_pos in state.crops_cells:
		grid_logic.set_cell(obstacle_pos, GridLogic.CellType.OBSTACLE)

	_clear_static_layers()
	_render_static_tiles(state)
	_center_camera(state.grid_size)

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

func _clear_static_layers():
	target_layer.clear()
	water_layer.clear()
	grass_layer.clear()
	path_layer.clear()
	crops_layer.clear()

func _render_static_tiles(state: Dictionary):
	for pos in state.water_cells:
		var atlas = state.water_variant_map.get(pos, Vector2i.ZERO)
		water_layer.set_cell(pos, WATER_SOURCE, atlas)

	for pos in state.grass_cells:
		var atlas = state.grass_variant_map.get(pos, Vector2i.ZERO)
		grass_layer.set_cell(pos, GRASS_SOURCE, atlas)

	path_layer.set_cells_terrain_connect(state.path_boundary_cells, PATH_TERRAIN_SET, PATH_TERRAIN)

	for pos in state.crops_cells:
		var atlas = CROPS_VARIANTS[abs(pos.x * 13 + pos.y * 7) % CROPS_VARIANTS.size()]
		crops_layer.set_cell(pos, CROPS_SOURCE, atlas)

func _center_camera(grid_size: Vector2i):
	camera.position = Vector2(grid_size) * GameEvents.cell_size * 0.5

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

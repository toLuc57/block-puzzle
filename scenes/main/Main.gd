extends Control

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
	# Initialize Logic
	grid_logic = GridLogic.new(10, 10)
	level_gen = LevelGenerator.new()
	level_gen.grid_logic = grid_logic
	
	# Connect signals
	GameEvents.block_moved.connect(_on_block_moved)
	GameEvents.next_level_requested.connect(_on_next_level_requested)
	GameEvents.reset_requested.connect(_on_reset_requested)
	GameEvents.win_condition_met.connect(_on_win)
	
	# Start game
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
	
	# Initial progress update
	_update_progress()
	GameEvents.score_updated.emit(0, steps)

func _setup_level(state: Dictionary):
	# Clear existing
	for child in grid_container.get_children():
		child.queue_free()
	
	grid_logic.blocks.clear()
	grid_logic.targets = state.targets
	grid_logic.grid = [] # Reset grid
	grid_logic._init(10, 10) # Re-init grid

	# Setup targets logic
	target_layer.clear()
	for target_pos in state.targets:
		grid_logic.set_cell(target_pos, GridLogic.CellType.TARGET)
		target_layer.set_cell(target_pos, 0, Vector2i(3, 3))
	
	# Spawn Blocks
	for b_data in state.blocks:
		var block = block_scene.instantiate()
		block.grid_logic = grid_logic
		block.grid_pos = b_data.pos
		block.position = Vector2(b_data.pos) * GameEvents.cell_size
		block.data = gray_block_res if b_data.type == "gray-block" else ice_block_res
		grid_logic.blocks[b_data.pos] = block
		grid_container.add_child(block)
		
	# Spawn Player
	var player = player_scene.instantiate()
	player.grid_logic = grid_logic
	player.grid_pos = state.player_pos
	player.position = Vector2(state.player_pos) * GameEvents.cell_size
	grid_container.add_child(player)
	
	# Record for Undo
	GameState.record_initial_state(player, grid_logic)

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

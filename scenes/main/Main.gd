extends Node2D

@onready var grid_container = %GridContainer
@onready var target_layer = %TargetLayer
@onready var score_label = $HUD/Control/ScoreLabel
@onready var win_label = $HUD/Control/WinLabel

var grid_logic: GridLogic
var level_gen: LevelGenerator

var player_scene = preload("res://scenes/game_objects/Player.tscn")
var block_scene = preload("res://scenes/game_objects/Block.tscn")
var gray_block_res = preload("res://resources/blocks/gray_block.tres")
var ice_block_res = preload("res://resources/blocks/ice_block.tres")

func _ready():
	# Initial UI state
	win_label.hide()
	score_label.text = "Score: 0"
	
	# Connect signals
	GameEvents.win_condition_met.connect(_on_win)
	
	# Initialize logic
	grid_logic = GridLogic.new(10, 10)
	level_gen = LevelGenerator.new()
	level_gen.grid_logic = grid_logic
	
	# Generate and setup level
	var level_state = level_gen.generate_level(5, 20)
	_setup_level(level_state)

func _setup_level(state: Dictionary):
	# Clear existing (if any)
	for child in grid_container.get_children():
		child.queue_free()
	
	grid_logic.blocks.clear()
	grid_logic.targets = state.targets

	# Setup targets logic
	for target_pos in state.targets:
		grid_logic.set_cell(target_pos, GridLogic.CellType.TARGET)
		# Set tile index 0 for target marker (X)
		target_layer.set_cell(target_pos, 0, Vector2i(3, 3))
	
	# Spawn Blocks
	for b_data in state.blocks:
		var block = block_scene.instantiate()
		
		block.grid_logic = grid_logic
		block.grid_pos = b_data.pos
		block.position = Vector2(b_data.pos) * GameEvents.cell_size
		
		if b_data.type == "gray-block":
			block.data = gray_block_res
		else:
			block.data = ice_block_res
			
		grid_logic.blocks[b_data.pos] = block
		grid_container.add_child(block)
		
	# Spawn Player
	var player = player_scene.instantiate()

	player.grid_logic = grid_logic
	player.grid_pos = state.player_pos
	player.position = Vector2(state.player_pos) * GameEvents.cell_size
	grid_container.add_child(player)
	
func _on_win():
	win_label.show()

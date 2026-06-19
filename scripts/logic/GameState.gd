extends Node

var history: Array = []
var current_moves: int = 0
var target_moves: int = 0

var is_undoing: bool = false

# References for state capture
var grid_logic: GridLogic
var player: Node2D

func _ready():
	GameEvents.player_moved.connect(_on_player_moved)
	GameEvents.level_generated.connect(_on_level_generated)
	GameEvents.undo_requested.connect(undo)
	GameEvents.reset_requested.connect(reset)

func _on_level_generated(state: Dictionary):
	history.clear()
	current_moves = 0
	target_moves = state.get("target_moves", 0)
	# State will be captured after setup in Main.gd via record_initial_state()

func record_initial_state(p_node: Node2D, g_logic: GridLogic):
	player = p_node
	grid_logic = g_logic
	save_checkpoint()

func _on_player_moved(_from, _to):
	if is_undoing: return
	current_moves += 1
	save_checkpoint()
	GameEvents.score_updated.emit(current_moves, target_moves)

func save_checkpoint():
	var state = {
		"player_pos": player.grid_pos if player else Vector2i.ZERO,
		"block_positions": {} # Block Node -> Vector2i
	}
	
	if grid_logic:
		for pos in grid_logic.blocks:
			var block = grid_logic.blocks[pos]
			state.block_positions[block] = pos
			
	history.append(state)

func undo():
	if is_undoing or history.size() <= 1: return
	
	is_undoing = true
	history.pop_back() # Remove current state
	var prev_state = history.back()
	
	# Restore state
	if player:
		player.grid_pos = prev_state.player_pos
		player.position = Vector2(prev_state.player_pos) * GameEvents.cell_size
		
	if grid_logic:
		grid_logic.blocks.clear()
		for block in prev_state.block_positions:
			var pos = prev_state.block_positions[block]
			grid_logic.blocks[pos] = block
			block.grid_pos = pos
			block.position = Vector2(pos) * GameEvents.cell_size
			
	current_moves -= 1
	GameEvents.score_updated.emit(current_moves, target_moves)
	
	# Trigger progress update
	GameEvents.block_moved.emit(null, Vector2i.ZERO, Vector2i.ZERO)
	
	is_undoing = false

func reset():
	# Handled by Main.gd re-generating or re-setting level
	pass

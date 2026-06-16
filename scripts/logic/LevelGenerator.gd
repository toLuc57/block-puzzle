extends RefCounted
class_name LevelGenerator

var grid_logic: GridLogic

func generate_level(block_count: int, steps: int) -> Dictionary:
	var state = {
		"blocks": [], # Array of {pos, type_id}
		"targets": [], # Array of pos
		"player_pos": Vector2i.ZERO
	}
	
	# 1. Place targets and blocks at win positions
	var used_pos = []
	for i in range(block_count):
		var pos = _get_random_free_pos(used_pos)
		used_pos.append(pos)
		state.targets.append(pos)
		var type = "gray-block" if randf() > 0.3 else "ice-block"
		state.blocks.append({"pos": pos, "type": type})
		
	# 2. Set initial player pos adjacent to a block
	state.player_pos = _get_random_adjacent(state.blocks[0].pos)
	
	# Update logic for pull simulation
	_sync_logic_to_state(state)
	
	# 3. Perform pull moves
	for i in range(steps):
		var block_idx = randi() % block_count
		var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
		dirs.shuffle()
		
		var moved = false
		for dir in dirs:
			if _attempt_pull(block_idx, dir, state):
				moved = true
				break
	
	# Final state
	state.player_pos = grid_logic.player_pos
	state.blocks = []
	for pos in grid_logic.blocks.keys():
		var block_node = grid_logic.blocks[pos]
		# In real impl, we'd store type data in the dictionary or meta
		state.blocks.append({"pos": pos, "type": "gray-block"}) # Placeholder
	
	GameEvents.level_generated.emit(state)
	return state

func _get_random_free_pos(exclude: Array) -> Vector2i:
	while true:
		var pos = Vector2i(randi() % 10, randi() % 10)
		if not pos in exclude:
			return pos
	return Vector2i.ZERO

func _get_random_adjacent(pos: Vector2i) -> Vector2i:
	var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	return pos + dirs[randi() % 4]

func _sync_logic_to_state(state: Dictionary):
	grid_logic.blocks.clear()
	for b in state.blocks:
		grid_logic.blocks[b.pos] = "DummyNode"
	grid_logic.player_pos = state.player_pos

func _attempt_pull(block_idx: int, dir: Vector2i, state: Dictionary) -> bool:
	# Pull move: player is at pos + dir, pulls block at pos to pos + dir
	# and player moves to pos + dir*2
	var block_current_pos = Vector2i.ZERO
	# Find block pos (this is inefficient but fine for gen)
	var keys = grid_logic.blocks.keys()
	block_current_pos = keys[block_idx]
	
	# Player must move to block_current_pos, and block must move to block_current_pos + dir
	# Actually, standard pull is: player at B+D pulls B to B-D? 
	# No, reverse of push (P at 0, B at 1, push B to 2, P ends at 1)
	# Reverse: P at 1, B at 2, pull B to 1, P ends at 0.
	
	var pull_target = block_current_pos + dir # Where block will go
	var player_target = pull_target + dir # Where player will end up
	
	if grid_logic.is_within_bounds(pull_target) and grid_logic.is_within_bounds(player_target):
		if not grid_logic.is_occupied(pull_target) and grid_logic.get_cell(pull_target) != GridLogic.CellType.WALL:
			if not grid_logic.is_occupied(player_target) and grid_logic.get_cell(player_target) != GridLogic.CellType.WALL:
				grid_logic.move_block(block_current_pos, pull_target)
				grid_logic.player_pos = player_target
				return true
	return false

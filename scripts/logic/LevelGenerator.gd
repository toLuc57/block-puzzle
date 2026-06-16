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
	var block_types = {} # Vector2i -> String
	
	for i in range(block_count):
		var pos = _get_random_free_pos(used_pos)
		used_pos.append(pos)
		state.targets.append(pos)
		var type = "gray-block" if randf() > 0.3 else "ice-block"
		block_types[pos] = type
		state.blocks.append({"pos": pos, "type": type})
		
	# 2. Set initial player pos adjacent to a block
	state.player_pos = _get_random_adjacent(state.blocks[0].pos)
	
	# Update logic for pull simulation
	_sync_logic_to_state(state)
	
	# 3. Perform pull moves
	for i in range(steps):
		var keys = grid_logic.blocks.keys()
		if keys.is_empty(): break
		
		var block_idx = randi() % keys.size()
		var block_pos = keys[block_idx]
		var type = block_types[block_pos]
		
		var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
		dirs.shuffle()
		
		for dir in dirs:
			var pull_target = block_pos + dir
			var player_target = pull_target + dir
			
			if grid_logic.is_within_bounds(pull_target) and grid_logic.is_within_bounds(player_target):
				if not grid_logic.is_occupied(pull_target) and grid_logic.get_cell(pull_target) != GridLogic.CellType.WALL:
					if not grid_logic.is_occupied(player_target) and grid_logic.get_cell(player_target) != GridLogic.CellType.WALL:
						# Perform pull
						grid_logic.move_block(block_pos, pull_target)
						grid_logic.player_pos = player_target
						# Update local types tracking
						block_types.erase(block_pos)
						block_types[pull_target] = type
						block_pos = pull_target # Update for loop if needed
						break
	
	# Construct final state from logic
	state.player_pos = grid_logic.player_pos
	state.blocks = []
	for pos in grid_logic.blocks.keys():
		state.blocks.append({
			"pos": pos,
			"type": block_types[pos]
		})
	
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

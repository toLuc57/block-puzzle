extends RefCounted
class_name LevelGenerator

const DISPLAY_SIZE := Vector2i(12, 10)
const PUZZLE_ORIGIN := Vector2i(1, 1)
const PUZZLE_SIZE := Vector2i(10, 8)
const INTERIOR_ORIGIN := Vector2i(2, 2)
const INTERIOR_SIZE := Vector2i(8, 6)
const MAX_GENERATION_ATTEMPTS := 40

var grid_logic: GridLogic

func generate_level(block_count: int, steps: int) -> Dictionary:
	for _attempt in range(MAX_GENERATION_ATTEMPTS):
		var mask = _build_playable_mask()
		var obstacles = _pick_obstacles(mask.floor_cells, block_count)
		var usable_floor = _subtract_cells(mask.floor_cells, obstacles)
		if usable_floor.size() < block_count * 2 + 2:
			continue
		if not _is_connected(usable_floor):
			continue

		var targets = _pick_unique_cells(usable_floor, block_count)
		if targets.size() != block_count:
			continue

		var blocks = []
		var block_types = {}
		for target_pos in targets:
			var type = "gray-block" if randf() > 0.3 else "ice-block"
			block_types[target_pos] = type
			blocks.append({"pos": target_pos, "type": type})

		var player_pos = _pick_player_spawn(mask.boundary_cells, usable_floor, obstacles, targets)
		if player_pos == Vector2i(-1, -1):
			continue

		var state = {
			"grid_size": DISPLAY_SIZE,
			"playable_mask": mask,
			"obstacles": obstacles,
			"targets": targets,
			"blocks": blocks,
			"player_pos": player_pos,
			"target_moves": steps
		}

		_sync_logic_to_state(state)
		_apply_reverse_generation(block_types, steps)
		state.player_pos = grid_logic.player_pos
		state.blocks = []
		for pos in grid_logic.blocks.keys():
			state.blocks.append({
				"pos": pos,
				"type": block_types.get(pos, "gray-block")
			})

		if _state_is_valid(state, block_count):
			GameEvents.level_generated.emit(state)
			return state

	var fallback_state = _build_fallback_state(block_count, steps)
	GameEvents.level_generated.emit(fallback_state)
	return fallback_state

func _build_playable_mask() -> Dictionary:
	var floor_cells: Array = []
	var start = INTERIOR_ORIGIN + Vector2i(INTERIOR_SIZE.x / 2, INTERIOR_SIZE.y / 2)
	floor_cells.append(start)

	var desired_size = 22 + (randi() % 11)
	var frontier = _get_neighbors(start, INTERIOR_ORIGIN, INTERIOR_SIZE)

	while floor_cells.size() < desired_size and not frontier.is_empty():
		frontier.shuffle()
		var candidate = frontier.pop_back()
		if candidate in floor_cells:
			continue
		floor_cells.append(candidate)
		for neighbor in _get_neighbors(candidate, INTERIOR_ORIGIN, INTERIOR_SIZE):
			if neighbor in floor_cells or neighbor in frontier:
				continue
			frontier.append(neighbor)

	var boundary_cells: Array = []
	for pos in _list_rect_cells(PUZZLE_ORIGIN, PUZZLE_SIZE):
		if pos in floor_cells:
			continue
		for neighbor in _get_neighbors(pos, PUZZLE_ORIGIN, PUZZLE_SIZE):
			if neighbor in floor_cells:
				boundary_cells.append(pos)
				break

	var outer_cells: Array = []
	for pos in _list_rect_cells(Vector2i.ZERO, DISPLAY_SIZE):
		if pos in floor_cells or pos in boundary_cells:
			continue
		outer_cells.append(pos)

	return {
		"floor_cells": floor_cells,
		"boundary_cells": boundary_cells,
		"outer_cells": outer_cells,
		"is_connected": _is_connected(floor_cells)
	}

func _pick_obstacles(floor_cells: Array, block_count: int) -> Array:
	var candidates = floor_cells.duplicate()
	candidates.shuffle()
	var max_obstacles = min(4, max(2, block_count + 1))
	var desired = min(max_obstacles, max(0, floor_cells.size() / 8))
	var obstacles: Array = []

	for pos in candidates:
		if obstacles.size() >= desired:
			break
		if _touches_too_many_floor_neighbors(pos, floor_cells):
			continue
		obstacles.append(pos)

	return obstacles

func _touches_too_many_floor_neighbors(pos: Vector2i, floor_cells: Array) -> bool:
	var neighbors_on_floor = 0
	for neighbor in _get_neighbors(pos, INTERIOR_ORIGIN, INTERIOR_SIZE):
		if neighbor in floor_cells:
			neighbors_on_floor += 1
	return neighbors_on_floor >= 4

func _pick_unique_cells(cells: Array, count: int) -> Array:
	var shuffled = cells.duplicate()
	shuffled.shuffle()
	var result: Array = []
	for pos in shuffled:
		result.append(pos)
		if result.size() == count:
			break
	return result

func _pick_player_spawn(boundary_cells: Array, floor_cells: Array, obstacles: Array, targets: Array) -> Vector2i:
	var forbidden = obstacles.duplicate()
	forbidden.append_array(targets)
	var candidates: Array = []

	for pos in _list_rect_cells(Vector2i.ZERO, DISPLAY_SIZE):
		if pos in forbidden or pos in floor_cells:
			continue
		for neighbor in _get_neighbors(pos, Vector2i.ZERO, DISPLAY_SIZE):
			if neighbor in boundary_cells:
				candidates.append(pos)
				break

	if not candidates.is_empty():
		candidates.shuffle()
		return candidates[0]

	var fallback = _subtract_cells(floor_cells, targets)

	if not fallback.is_empty():
		fallback.shuffle()
		return fallback[0]

	return Vector2i(-1, -1)

func _apply_reverse_generation(block_types: Dictionary, steps: int):
	for _step in range(steps):
		var block_positions = grid_logic.blocks.keys()
		if block_positions.is_empty():
			break
		block_positions.shuffle()

		var moved = false
		for block_pos in block_positions:
			var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
			dirs.shuffle()
			for dir in dirs:
				var pull_target = block_pos + dir
				var player_target = pull_target + dir
				if not grid_logic.can_block_enter(pull_target):
					continue
				if not grid_logic.can_player_enter(player_target):
					continue
				grid_logic.move_block(block_pos, pull_target)
				grid_logic.player_pos = player_target
				var type = block_types.get(block_pos, "gray-block")
				block_types.erase(block_pos)
				block_types[pull_target] = type
				moved = true
				break
			if moved:
				break

func _sync_logic_to_state(state: Dictionary):
	grid_logic = GridLogic.new(state.grid_size.x, state.grid_size.y) if grid_logic == null else GridLogic.new(state.grid_size.x, state.grid_size.y)
	for boundary_pos in state.playable_mask.boundary_cells:
		grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)
	for obstacle_pos in state.obstacles:
		grid_logic.set_cell(obstacle_pos, GridLogic.CellType.OBSTACLE)
	grid_logic.targets = state.targets.duplicate()
	grid_logic.blocks.clear()
	for block_data in state.blocks:
		grid_logic.blocks[block_data.pos] = "DummyNode"
	grid_logic.player_pos = state.player_pos

func _state_is_valid(state: Dictionary, block_count: int) -> bool:
	if state.blocks.size() != block_count or state.targets.size() != block_count:
		return false
	if not state.playable_mask.is_connected:
		return false

	var floor_cells = state.playable_mask.floor_cells
	for target_pos in state.targets:
		if not target_pos in floor_cells:
			return false
	for block_data in state.blocks:
		if not block_data.pos in floor_cells:
			return false
		if block_data.pos in state.obstacles:
			return false
	if state.player_pos in state.obstacles:
		return false
	if not grid_logic.is_within_bounds(state.player_pos):
		return false

	var usable_floor = _subtract_cells(floor_cells, state.obstacles)
	return _is_connected(usable_floor)

func _build_fallback_state(block_count: int, steps: int) -> Dictionary:
	var floor_cells: Array = []
	for pos in _list_rect_cells(Vector2i(3, 3), Vector2i(6, 4)):
		floor_cells.append(pos)

	var boundary_cells: Array = []
	for pos in _list_rect_cells(PUZZLE_ORIGIN, PUZZLE_SIZE):
		if pos in floor_cells:
			continue
		for neighbor in _get_neighbors(pos, PUZZLE_ORIGIN, PUZZLE_SIZE):
			if neighbor in floor_cells:
				boundary_cells.append(pos)
				break

	var obstacles = [Vector2i(5, 4), Vector2i(7, 5)]
	var usable_floor = _subtract_cells(floor_cells, obstacles)
	var targets = usable_floor.slice(0, block_count)
	var blocks = []
	for index in range(block_count):
		blocks.append({
			"pos": targets[index],
			"type": "gray-block" if index % 2 == 0 else "ice-block"
		})

	return {
		"grid_size": DISPLAY_SIZE,
		"playable_mask": {
			"floor_cells": floor_cells,
			"boundary_cells": boundary_cells,
			"outer_cells": [],
			"is_connected": true
		},
		"obstacles": obstacles,
		"targets": targets,
		"blocks": blocks,
		"player_pos": Vector2i(2, 4),
		"target_moves": steps
	}

func _subtract_cells(source: Array, blocked: Array) -> Array:
	var result: Array = []
	for pos in source:
		if pos in blocked:
			continue
		result.append(pos)
	return result

func _is_connected(cells: Array) -> bool:
	if cells.is_empty():
		return false
	var open = [cells[0]]
	var visited: Array = []
	while not open.is_empty():
		var current = open.pop_back()
		if current in visited:
			continue
		visited.append(current)
		for neighbor in _get_neighbors(current, INTERIOR_ORIGIN, INTERIOR_SIZE):
			if neighbor in cells and not neighbor in visited:
				open.append(neighbor)
	return visited.size() == cells.size()

func _list_rect_cells(origin: Vector2i, size: Vector2i) -> Array:
	var cells: Array = []
	for x in range(origin.x, origin.x + size.x):
		for y in range(origin.y, origin.y + size.y):
			cells.append(Vector2i(x, y))
	return cells

func _get_neighbors(pos: Vector2i, origin: Vector2i, size: Vector2i) -> Array:
	var neighbors: Array = []
	var rect_end = origin + size
	for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
		var candidate = pos + dir
		if candidate.x < origin.x or candidate.x >= rect_end.x:
			continue
		if candidate.y < origin.y or candidate.y >= rect_end.y:
			continue
		neighbors.append(candidate)
	return neighbors

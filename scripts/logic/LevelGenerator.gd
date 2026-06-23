extends RefCounted
class_name LevelGenerator

const DISPLAY_SIZE := Vector2i(16, 14)
const GRASS_ORIGIN := Vector2i(1, 1)
const GRASS_SIZE := Vector2i(14, 12)
const MAX_GENERATION_ATTEMPTS := 40
const WATER_VARIANTS := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0)]
const GRASS_VARIANTS := [
	Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0),
	Vector2i(4, 0), Vector2i(5, 0), Vector2i(6, 0), Vector2i(7, 0),
	Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1),
	Vector2i(4, 1), Vector2i(5, 1), Vector2i(6, 1)
]

var grid_logic: GridLogic

func generate_level(block_count: int, steps: int) -> Dictionary:
	for _attempt in range(MAX_GENERATION_ATTEMPTS):
		var water_cells = _list_rect_cells(Vector2i.ZERO, DISPLAY_SIZE)
		var grass_cells = _list_rect_cells(GRASS_ORIGIN, GRASS_SIZE)
		var path_boundary_cells = _build_path_boundary()
		var crops_cells = _pick_crops(grass_cells, path_boundary_cells, block_count)
		var usable_cells = _subtract_cells(grass_cells, path_boundary_cells + crops_cells)
		if usable_cells.size() < block_count * 2 + 2:
			continue
		if not _is_connected(usable_cells, GRASS_ORIGIN, GRASS_SIZE):
			continue

		var targets = _pick_unique_cells(usable_cells, block_count)
		if targets.size() != block_count:
			continue

		var blocks = []
		var block_types = {}
		for target_pos in targets:
			var type = "gray-block" if randf() > 0.3 else "ice-block"
			block_types[target_pos] = type
			blocks.append({"pos": target_pos, "type": type})

		var player_pos = _pick_player_spawn(usable_cells, targets)
		if player_pos == Vector2i(-1, -1):
			continue

		var state = {
			"grid_size": DISPLAY_SIZE,
			"water_cells": water_cells,
			"grass_cells": grass_cells,
			"water_variant_map": _build_variant_map(water_cells, WATER_VARIANTS),
			"grass_variant_map": _build_variant_map(grass_cells, GRASS_VARIANTS),
			"path_boundary_cells": path_boundary_cells,
			"crops_cells": crops_cells,
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

func _build_path_boundary() -> Array:
	var boundary_cells = _build_perimeter_boundary()
	var dent_builders = [
		func() -> Array: return _build_vertical_dent(true),
		func() -> Array: return _build_vertical_dent(false),
		func() -> Array: return _build_horizontal_dent(true),
		func() -> Array: return _build_horizontal_dent(false)
	]
	dent_builders.shuffle()
	var dent_count = randi_range(1, 3)
	for index in range(dent_count):
		for pos in dent_builders[index].call():
			if not pos in boundary_cells:
				boundary_cells.append(pos)
	return boundary_cells

func _build_perimeter_boundary() -> Array:
	var boundary_cells: Array = []
	var max_x = GRASS_ORIGIN.x + GRASS_SIZE.x - 1
	var max_y = GRASS_ORIGIN.y + GRASS_SIZE.y - 1

	for x in range(GRASS_ORIGIN.x, max_x + 1):
		boundary_cells.append(Vector2i(x, GRASS_ORIGIN.y))
		boundary_cells.append(Vector2i(x, max_y))
	for y in range(GRASS_ORIGIN.y + 1, max_y):
		boundary_cells.append(Vector2i(GRASS_ORIGIN.x, y))
		boundary_cells.append(Vector2i(max_x, y))

	return boundary_cells

func _build_vertical_dent(from_top: bool) -> Array:
	var dent: Array = []
	var x = randi_range(GRASS_ORIGIN.x + 2, GRASS_ORIGIN.x + GRASS_SIZE.x - 3)
	var start_y = GRASS_ORIGIN.y if from_top else GRASS_ORIGIN.y + GRASS_SIZE.y - 1
	var direction = 1 if from_top else -1
	var depth = randi_range(2, 4)

	for step in range(1, depth + 1):
		dent.append(Vector2i(x, start_y + step * direction))

	return dent

func _build_horizontal_dent(from_left: bool) -> Array:
	var dent: Array = []
	var y = randi_range(GRASS_ORIGIN.y + 2, GRASS_ORIGIN.y + GRASS_SIZE.y - 3)
	var start_x = GRASS_ORIGIN.x if from_left else GRASS_ORIGIN.x + GRASS_SIZE.x - 1
	var direction = 1 if from_left else -1
	var depth = randi_range(2, 4)

	for step in range(1, depth + 1):
		dent.append(Vector2i(start_x + step * direction, y))

	return dent

func _pick_crops(grass_cells: Array, path_boundary_cells: Array, block_count: int) -> Array:
	var candidates = _subtract_cells(grass_cells, path_boundary_cells)
	candidates.shuffle()
	var max_crops = min(6, max(2, block_count + 1))
	var desired = min(max_crops, max(2, int(grass_cells.size() / 24)))
	var crops: Array = []

	for pos in candidates:
		if crops.size() >= desired:
			break
		if _touches_too_many_blocked_neighbors(pos, path_boundary_cells, crops):
			continue
		crops.append(pos)

	return crops

func _touches_too_many_blocked_neighbors(pos: Vector2i, path_boundary_cells: Array, crops: Array) -> bool:
	var blocked_neighbors = 0
	for neighbor in _get_neighbors(pos, GRASS_ORIGIN, GRASS_SIZE):
		if neighbor in path_boundary_cells or neighbor in crops:
			blocked_neighbors += 1
	return blocked_neighbors >= 3

func _build_variant_map(cells: Array, variants: Array) -> Dictionary:
	var result := {}
	for pos in cells:
		var index = abs(pos.x * 31 + pos.y * 17 + int(pos.x * pos.y)) % variants.size()
		result[pos] = variants[index]
	return result

func _pick_unique_cells(cells: Array, count: int) -> Array:
	var shuffled = cells.duplicate()
	shuffled.shuffle()
	var result: Array = []
	for pos in shuffled:
		result.append(pos)
		if result.size() == count:
			break
	return result

func _pick_player_spawn(usable_cells: Array, targets: Array) -> Vector2i:
	var candidates = _subtract_cells(usable_cells, targets)
	if candidates.is_empty():
		return Vector2i(-1, -1)
	candidates.shuffle()
	return candidates[0]

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
	grid_logic = GridLogic.new(state.grid_size.x, state.grid_size.y)
	for boundary_pos in state.path_boundary_cells:
		grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)
	for obstacle_pos in state.crops_cells:
		grid_logic.set_cell(obstacle_pos, GridLogic.CellType.OBSTACLE)
	grid_logic.targets = state.targets.duplicate()
	grid_logic.blocks.clear()
	for block_data in state.blocks:
		grid_logic.blocks[block_data.pos] = "DummyNode"
	grid_logic.player_pos = state.player_pos

func _state_is_valid(state: Dictionary, block_count: int) -> bool:
	if state.blocks.size() != block_count or state.targets.size() != block_count:
		return false
	if state.water_cells.size() != DISPLAY_SIZE.x * DISPLAY_SIZE.y:
		return false
	if state.grass_cells.size() != GRASS_SIZE.x * GRASS_SIZE.y:
		return false

	for pos in state.path_boundary_cells:
		if not pos in state.grass_cells:
			return false
	for pos in state.crops_cells:
		if not pos in state.grass_cells or pos in state.path_boundary_cells:
			return false

	var usable_cells = _subtract_cells(state.grass_cells, state.path_boundary_cells + state.crops_cells)
	if not _is_connected(usable_cells, GRASS_ORIGIN, GRASS_SIZE):
		return false

	for target_pos in state.targets:
		if not target_pos in usable_cells:
			return false
	for block_data in state.blocks:
		if not block_data.pos in usable_cells:
			return false
	if not state.player_pos in usable_cells:
		return false
	if not grid_logic.is_within_bounds(state.player_pos):
		return false

	return true

func _build_fallback_state(block_count: int, steps: int) -> Dictionary:
	var water_cells = _list_rect_cells(Vector2i.ZERO, DISPLAY_SIZE)
	var grass_cells = _list_rect_cells(GRASS_ORIGIN, GRASS_SIZE)
	var path_boundary_cells = _build_perimeter_boundary()
	var crops_cells = [Vector2i(5, 5), Vector2i(10, 8)]
	var usable_cells = _subtract_cells(grass_cells, path_boundary_cells + crops_cells)
	var targets = usable_cells.slice(0, block_count)
	var blocks = []
	for index in range(block_count):
		blocks.append({
			"pos": targets[index],
			"type": "gray-block" if index % 2 == 0 else "ice-block"
		})

	return {
		"grid_size": DISPLAY_SIZE,
		"water_cells": water_cells,
		"grass_cells": grass_cells,
		"water_variant_map": _build_variant_map(water_cells, WATER_VARIANTS),
		"grass_variant_map": _build_variant_map(grass_cells, GRASS_VARIANTS),
		"path_boundary_cells": path_boundary_cells,
		"crops_cells": crops_cells,
		"targets": targets,
		"blocks": blocks,
		"player_pos": usable_cells[block_count],
		"target_moves": steps
	}

func _subtract_cells(source: Array, blocked: Array) -> Array:
	var result: Array = []
	for pos in source:
		if pos in blocked:
			continue
		result.append(pos)
	return result

func _is_connected(cells: Array, origin: Vector2i, size: Vector2i) -> bool:
	if cells.is_empty():
		return false
	var open = [cells[0]]
	var visited: Array = []
	while not open.is_empty():
		var current = open.pop_back()
		if current in visited:
			continue
		visited.append(current)
		for neighbor in _get_neighbors(current, origin, size):
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

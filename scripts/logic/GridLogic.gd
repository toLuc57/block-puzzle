extends RefCounted
class_name GridLogic

enum CellType { FLOOR, BOUNDARY, OBSTACLE, OUTER_WALL }

var width: int = 12
var height: int = 10
var grid: Array = []
var blocks: Dictionary = {} # Vector2i -> Block Node
var player_pos: Vector2i = Vector2i.ZERO
var targets: Array = []

func _init(w: int = 12, h: int = 10):
	width = w
	height = h
	targets = []
	blocks = {}
	_clear_grid(CellType.FLOOR)

func _clear_grid(fill_type: CellType):
	grid.resize(width)
	for x in range(width):
		grid[x] = []
		grid[x].resize(height)
		for y in range(height):
			grid[x][y] = fill_type

func set_cell(pos: Vector2i, type: CellType):
	if is_within_bounds(pos):
		grid[pos.x][pos.y] = type

func get_cell(pos: Vector2i) -> CellType:
	if is_within_bounds(pos):
		return grid[pos.x][pos.y]
	return CellType.OUTER_WALL

func is_within_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

func is_occupied(pos: Vector2i) -> bool:
	return blocks.has(pos)

func is_target(pos: Vector2i) -> bool:
	return pos in targets

func can_player_enter(pos: Vector2i) -> bool:
	if not is_within_bounds(pos):
		return false
	if get_cell(pos) in [CellType.OBSTACLE, CellType.OUTER_WALL]:
		return false
	return not is_occupied(pos)

func can_block_enter(pos: Vector2i) -> bool:
	if not is_within_bounds(pos):
		return false
	if get_cell(pos) in [CellType.BOUNDARY, CellType.OBSTACLE, CellType.OUTER_WALL]:
		return false
	return not is_occupied(pos)

func can_place_generator_actor(pos: Vector2i) -> bool:
	if not is_within_bounds(pos):
		return false
	if get_cell(pos) != CellType.FLOOR:
		return false
	return not is_occupied(pos)

func move_block(from: Vector2i, to: Vector2i):
	if blocks.has(from):
		var block = blocks[from]
		blocks.erase(from)
		blocks[to] = block

func check_win() -> bool:
	if targets.is_empty():
		return false
	for target_pos in targets:
		if not blocks.has(target_pos):
			return false
	return true

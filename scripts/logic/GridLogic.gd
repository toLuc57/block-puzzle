extends RefCounted
class_name GridLogic

enum CellType { EMPTY, WALL, TARGET }

var width: int = 10
var height: int = 10
var grid: Array = []
var blocks: Dictionary = {} # Vector2i -> Block Node
var player_pos: Vector2i = Vector2i.ZERO
var targets: Array[Vector2i] = []

func _init(w: int = 10, h: int = 10):
	width = w
	height = h
	grid.resize(width)
	for x in range(width):
		grid[x] = []
		grid[x].resize(height)
		for y in range(height):
			grid[x][y] = CellType.EMPTY

func set_cell(pos: Vector2i, type: CellType):
	if is_within_bounds(pos):
		grid[pos.x][pos.y] = type
		if type == CellType.TARGET:
			if not pos in targets:
				targets.append(pos)

func get_cell(pos: Vector2i) -> CellType:
	if is_within_bounds(pos):
		return grid[pos.x][pos.y]
	return CellType.WALL

func is_within_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < width and pos.y >= 0 and pos.y < height

func is_occupied(pos: Vector2i) -> bool:
	return blocks.has(pos)

func move_block(from: Vector2i, to: Vector2i):
	if blocks.has(from):
		var block = blocks[from]
		blocks.erase(from)
		blocks[to] = block

func check_win() -> bool:
	if targets.is_empty(): return false
	for target_pos in targets:
		if not blocks.has(target_pos):
			return false
	return true

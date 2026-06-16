extends "res://addons/gut/test.gd"

var grid_logic: GridLogic
var level_gen: LevelGenerator

func before_each():
	grid_logic = GridLogic.new(10, 10)
	level_gen = LevelGenerator.new()
	level_gen.grid_logic = grid_logic

func test_pull_move_gray_block():
	var win_pos = Vector2i(5, 5)
	var pull_dir = Vector2i(1, 0) # Pulling from right to left
	var block_new_pos = win_pos + pull_dir
	var player_new_pos = block_new_pos + pull_dir
	
	# Initial state: block on target
	grid_logic.blocks[win_pos] = "BlockNode"
	grid_logic.player_pos = win_pos + pull_dir # Player must be adjacent to pull
	
	# Simulation of pull move logic
	if grid_logic.is_within_bounds(block_new_pos) and grid_logic.is_within_bounds(player_new_pos):
		if not grid_logic.is_occupied(block_new_pos) and grid_logic.get_cell(block_new_pos) != GridLogic.CellType.WALL:
			grid_logic.move_block(win_pos, block_new_pos)
			grid_logic.player_pos = player_new_pos
			
	assert_eq(grid_logic.blocks.has(block_new_pos), true, "Block should be pulled")
	assert_eq(grid_logic.player_pos, player_new_pos, "Player should move back")

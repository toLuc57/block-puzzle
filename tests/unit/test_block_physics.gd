extends "res://addons/gut/test.gd"

var grid_logic: GridLogic

func before_each():
	grid_logic = GridLogic.new(10, 10)

func test_gray_block_push():
	var block_pos = Vector2i(6, 5)
	var dir = Vector2i(1, 0)
	var target_pos = block_pos + dir
	
	grid_logic.blocks[block_pos] = "GrayBlockNode"
	
	# Simulate push logic for GrayBlock
	if grid_logic.is_within_bounds(target_pos) and grid_logic.get_cell(target_pos) != GridLogic.CellType.WALL and not grid_logic.is_occupied(target_pos):
		grid_logic.move_block(block_pos, target_pos)
		
	assert_eq(grid_logic.blocks.has(target_pos), true, "Gray block should move 1 cell")
	assert_eq(grid_logic.blocks.has(block_pos), false, "Gray block should leave old cell")

func test_ice_block_slide():
	var block_pos = Vector2i(6, 5)
	var dir = Vector2i(1, 0)
	var wall_pos = Vector2i(9, 5)
	
	grid_logic.set_cell(wall_pos, GridLogic.CellType.WALL)
	grid_logic.blocks[block_pos] = "IceBlockNode"
	
	# Simulate slide logic
	var current_pos = block_pos
	while true:
		var next_pos = current_pos + dir
		if not grid_logic.is_within_bounds(next_pos) or grid_logic.get_cell(next_pos) == GridLogic.CellType.WALL or grid_logic.is_occupied(next_pos):
			break
		current_pos = next_pos
	
	if current_pos != block_pos:
		grid_logic.move_block(block_pos, current_pos)
		
	assert_eq(grid_logic.blocks.has(Vector2i(8, 5)), true, "Ice block should slide until wall")
	assert_eq(grid_logic.blocks.has(block_pos), false)

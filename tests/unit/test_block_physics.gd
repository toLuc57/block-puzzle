extends "res://addons/gut/test.gd"

var grid_logic: GridLogic

func before_each():
	grid_logic = GridLogic.new(16, 14)

func test_gray_block_moves_one_floor_cell():
	var block_pos = Vector2i(5, 5)
	var target_pos = Vector2i(6, 5)
	grid_logic.blocks[block_pos] = "GrayBlockNode"

	if grid_logic.can_block_enter(target_pos):
		grid_logic.move_block(block_pos, target_pos)

	assert_eq(grid_logic.blocks.has(target_pos), true, "Gray block should move one floor cell")
	assert_eq(grid_logic.blocks.has(block_pos), false, "Gray block should leave old cell")

func test_gray_block_blocked_by_water_and_boundary():
	var block_pos = Vector2i(5, 5)
	var water_pos = Vector2i(6, 5)
	var boundary_pos = Vector2i(7, 5)
	grid_logic.blocks[block_pos] = "GrayBlockNode"
	grid_logic.set_cell(water_pos, GridLogic.CellType.WATER)
	grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)

	assert_false(grid_logic.can_block_enter(water_pos), "Gray block should be blocked by water")
	assert_false(grid_logic.can_block_enter(boundary_pos), "Gray block should be blocked by puzzle boundary")

func test_ice_block_stops_at_obstacle():
	var block_pos = Vector2i(5, 5)
	var obstacle_pos = Vector2i(8, 5)
	var dir = Vector2i.RIGHT
	grid_logic.blocks[block_pos] = "IceBlockNode"
	grid_logic.set_cell(obstacle_pos, GridLogic.CellType.OBSTACLE)

	var current_pos = block_pos
	while true:
		var next_pos = current_pos + dir
		if not grid_logic.can_block_enter(next_pos):
			break
		current_pos = next_pos

	assert_eq(current_pos, Vector2i(7, 5), "Ice block should stop before obstacle")

func test_ice_block_stops_at_boundary():
	var block_pos = Vector2i(5, 5)
	var boundary_pos = Vector2i(8, 5)
	var dir = Vector2i.RIGHT
	grid_logic.blocks[block_pos] = "IceBlockNode"
	grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)

	var current_pos = block_pos
	while true:
		var next_pos = current_pos + dir
		if not grid_logic.can_block_enter(next_pos):
			break
		current_pos = next_pos

	assert_eq(current_pos, Vector2i(7, 5), "Ice block should stop before boundary")

extends "res://addons/gut/test.gd"

var grid_logic: GridLogic

func before_each():
	grid_logic = GridLogic.new(12, 10)

func test_player_moves_to_empty_cell():
	var target_pos = Vector2i(5, 5)
	assert_eq(grid_logic.get_cell(target_pos), GridLogic.CellType.FLOOR)
	assert_true(grid_logic.can_player_enter(target_pos), "Player should be able to enter floor cells")

func test_player_can_cross_boundary():
	var boundary_pos = Vector2i(5, 5)
	grid_logic.set_cell(boundary_pos, GridLogic.CellType.BOUNDARY)
	assert_true(grid_logic.can_player_enter(boundary_pos), "Player should be able to cross boundary cells")

func test_player_blocked_by_obstacle_and_outer_wall():
	var obstacle_pos = Vector2i(6, 5)
	grid_logic.set_cell(obstacle_pos, GridLogic.CellType.OBSTACLE)
	assert_false(grid_logic.can_player_enter(obstacle_pos), "Player should be blocked by static obstacles")
	assert_false(grid_logic.can_player_enter(Vector2i(-1, 5)), "Player should be blocked outside the display grid")

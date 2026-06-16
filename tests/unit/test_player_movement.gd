extends "res://addons/gut/test.gd"

var grid_logic: GridLogic
var player_scene = load("res://scenes/game_objects/Player.tscn")

func before_each():
	grid_logic = GridLogic.new(10, 10)

func test_player_moves_to_empty_cell():
	var start_pos = Vector2i(5, 5)
	var dir = Vector2i(1, 0) # Right
	var target_pos = start_pos + dir
	
	# Initial check
	assert_eq(grid_logic.get_cell(target_pos), GridLogic.CellType.EMPTY)
	
	# Simulate movement logic (this will be in Player.gd)
	# For unit test, we test the logic that would be used
	if grid_logic.is_within_bounds(target_pos) and grid_logic.get_cell(target_pos) != GridLogic.CellType.WALL:
		grid_logic.player_pos = target_pos
	
	assert_eq(grid_logic.player_pos, target_pos, "Player should move to empty cell")

func test_player_blocked_by_wall():
	var start_pos = Vector2i(5, 5)
	var dir = Vector2i(1, 0)
	var wall_pos = start_pos + dir
	
	grid_logic.set_cell(wall_pos, GridLogic.CellType.WALL)
	
	# Logic simulation
	if grid_logic.is_within_bounds(wall_pos) and grid_logic.get_cell(wall_pos) != GridLogic.CellType.WALL:
		grid_logic.player_pos = wall_pos
	else:
		grid_logic.player_pos = start_pos
		
	assert_eq(grid_logic.player_pos, start_pos, "Player should be blocked by wall")

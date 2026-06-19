extends "res://addons/gut/test.gd"

var grid_logic: GridLogic
var level_gen: LevelGenerator

func before_each():
	grid_logic = GridLogic.new(12, 10)
	level_gen = LevelGenerator.new()
	level_gen.grid_logic = grid_logic

func test_generate_level_returns_12x10_payload():
	var state = level_gen.generate_level(3, 8)
	assert_eq(state.grid_size, Vector2i(12, 10), "Generated level should expose a 12x10 display grid")
	assert_true(state.playable_mask.has("floor_cells"), "Payload should include playable floor cells")
	assert_true(state.playable_mask.has("boundary_cells"), "Payload should include boundary cells")
	assert_true(state.playable_mask.is_connected, "Playable mask should stay connected")

func test_generated_targets_blocks_and_player_stay_in_valid_cells():
	var state = level_gen.generate_level(3, 8)
	var floor_cells = state.playable_mask.floor_cells

	for target_pos in state.targets:
		assert_true(target_pos in floor_cells, "Targets should stay on playable floor cells")

	for block_data in state.blocks:
		assert_true(block_data.pos in floor_cells, "Blocks should stay on playable floor cells")

	assert_false(state.player_pos in state.obstacles, "Player should not spawn inside obstacles")

func test_generated_layout_respects_playable_limits():
	var state = level_gen.generate_level(3, 8)

	for floor_pos in state.playable_mask.floor_cells:
		assert_true(floor_pos.x >= 2 and floor_pos.x <= 9, "Playable floor should stay inside the centered playable envelope")
		assert_true(floor_pos.y >= 2 and floor_pos.y <= 7, "Playable floor should stay inside the centered playable envelope")

	for boundary_pos in state.playable_mask.boundary_cells:
		assert_true(boundary_pos.x >= 1 and boundary_pos.x <= 10, "Boundary should stay inside the 10x8 puzzle area")
		assert_true(boundary_pos.y >= 1 and boundary_pos.y <= 8, "Boundary should stay inside the 10x8 puzzle area")

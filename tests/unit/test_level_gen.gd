extends "res://addons/gut/test.gd"

var grid_logic: GridLogic
var level_gen: LevelGenerator

func before_each():
	grid_logic = GridLogic.new(16, 14)
	level_gen = LevelGenerator.new()
	level_gen.grid_logic = grid_logic

func test_generate_level_returns_16x14_payload_with_full_water_and_grass_area():
	var state = level_gen.generate_level(3, 8)
	assert_eq(state.grid_size, Vector2i(16, 14), "Generated level should expose a 16x14 display grid")
	assert_eq(state.water_cells.size(), 16 * 14, "Water should cover the full display frame")
	assert_eq(state.grass_cells.size(), 14 * 12, "Grass should cover the 14x12 playable area")
	assert_true(state.grass_variant_map.size() == state.grass_cells.size(), "Grass variant metadata should exist for every grass cell")

func test_generated_targets_blocks_and_player_stay_in_valid_cells():
	var state = level_gen.generate_level(3, 8)
	var usable_cells = state.grass_cells.filter(func(pos): return not pos in state.path_boundary_cells and not pos in state.crops_cells)

	for target_pos in state.targets:
		assert_true(target_pos in usable_cells, "Targets should stay on usable grass cells")

	for block_data in state.blocks:
		assert_true(block_data.pos in usable_cells, "Blocks should stay on usable grass cells")

	assert_true(state.player_pos in usable_cells, "Player should spawn on a usable grass cell")

func test_generated_layout_respects_14x12_playable_limits():
	var state = level_gen.generate_level(3, 8)

	for grass_pos in state.grass_cells:
		assert_true(grass_pos.x >= 1 and grass_pos.x <= 14, "Grass should stay inside the 14x12 playable area")
		assert_true(grass_pos.y >= 1 and grass_pos.y <= 12, "Grass should stay inside the 14x12 playable area")

	for boundary_pos in state.path_boundary_cells:
		assert_true(boundary_pos in state.grass_cells, "Path boundary should stay inside the grass area")

func test_generated_path_boundary_is_orthogonal_only():
	var state = level_gen.generate_level(3, 8)
	for boundary_pos in state.path_boundary_cells:
		var orthogonal_neighbors = 0
		for dir in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
			if boundary_pos + dir in state.path_boundary_cells:
				orthogonal_neighbors += 1
		assert_true(orthogonal_neighbors >= 1, "Each boundary cell should connect orthogonally to the path shape")

func test_generated_layout_can_be_non_rectangular_but_still_valid():
	var state = level_gen.generate_level(3, 8)
	var interior_boundary_cells = state.path_boundary_cells.filter(func(pos):
		return pos.x > 1 and pos.x < 14 and pos.y > 1 and pos.y < 12
	)

	assert_true(interior_boundary_cells.size() > 0, "Generated path boundary should be able to form inward dents")
	assert_true(state.grass_cells.size() > state.path_boundary_cells.size(), "Playable grass should remain larger than the boundary shape")

func test_generated_spawns_do_not_overlap_and_stay_in_usable_cells():
	var state = level_gen.generate_level(3, 8)
	var usable_cells = state.grass_cells.filter(func(pos): return not pos in state.path_boundary_cells and not pos in state.crops_cells)
	var seen_positions = {}

	assert_true(state.player_pos in usable_cells, "Player should spawn on a usable grass cell")
	assert_false(state.player_pos in state.targets, "Player should not spawn on a target cell")

	for target_pos in state.targets:
		assert_true(target_pos in usable_cells, "Targets should spawn on usable grass cells")
		assert_false(seen_positions.has(target_pos), "Targets should not overlap each other or the player")
		seen_positions[target_pos] = true

	for block_data in state.blocks:
		assert_true(block_data.pos in usable_cells, "Blocks should spawn on usable grass cells")
		assert_false(seen_positions.has(block_data.pos), "Blocks should not overlap targets or the player")
		seen_positions[block_data.pos] = true

extends "res://addons/gut/test.gd"

func test_smoke():
	assert_true(true, "Should be true")

func test_grid_math():
	var pos = Vector2i(1, 1)
	var dir = Vector2i(1, 0)
	assert_eq(pos + dir, Vector2i(2, 1), "Grid addition should work")

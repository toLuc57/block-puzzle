extends "res://addons/gut/test.gd"

var HUD = load("res://scenes/ui/HUD.tscn")
var hud_instance

func before_each():
	hud_instance = HUD.instantiate()
	add_child(hud_instance)

func after_each():
	hud_instance.free()

func test_score_update():
	GameEvents.score_updated.emit(5, 10)
	assert_eq(hud_instance.move_label.text, "Moves: 5")
	assert_eq(hud_instance.target_label.text, "Target: 10")

func test_progress_update():
	GameEvents.progress_updated.emit(2, 3)
	assert_eq(hud_instance.progress_label.text, "Blocks: 2/3")

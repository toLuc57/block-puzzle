extends PanelContainer

@onready var move_label = %MoveLabel
@onready var target_label = %TargetLabel
@onready var progress_label = %ProgressLabel
@onready var undo_button = %UndoButton
@onready var reset_button = %ResetButton

func _ready():
	GameEvents.score_updated.connect(_on_score_updated)
	GameEvents.progress_updated.connect(_on_progress_updated)
	
	undo_button.pressed.connect(_on_undo_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

func _on_undo_pressed():
	GameEvents.undo_requested.emit()

func _on_reset_pressed():
	GameEvents.reset_requested.emit()

func _on_score_updated(current: int, target: int):
	move_label.text = "Moves: %d" % current
	target_label.text = "Target: %d" % target

func _on_progress_updated(placed: int, total: int):
	progress_label.text = "Blocks: %d/%d" % [placed, total]
	
	# Tween effect
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	# Color feedback (optional)
	modulate = Color.GREEN
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.2)

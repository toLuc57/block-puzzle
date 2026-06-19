extends PanelContainer

@onready var stats_label = %StatsLabel
@onready var next_button = %NextButton
@onready var replay_button = %ReplayButton

func _ready():
	next_button.pressed.connect(_on_next_pressed)
	replay_button.pressed.connect(_on_replay_pressed)
	
	# Listen for win to update stats
	GameEvents.win_condition_met.connect(_on_win)

func _on_win():
	stats_label.text = "Moves: %d" % GameState.current_moves

func _on_next_pressed():
	hide()
	GameEvents.next_level_requested.emit()

func _on_replay_pressed():
	hide()
	GameEvents.reset_requested.emit()

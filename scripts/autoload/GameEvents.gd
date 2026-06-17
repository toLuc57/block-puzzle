extends Node

var cell_size: int = 16

# Signals are used across the project to decouple components.
# They are emitted from various classes like Player.gd and Block.gd.
signal player_moved(from: Vector2i, to: Vector2i)
signal block_moved(block: Node2D, from: Vector2i, to: Vector2i)
signal win_condition_met()
signal level_generated(state: Dictionary)

# UI & GameState Signals
signal score_updated(current_moves: int, target_moves: int)
signal progress_updated(placed: int, total: int)
signal victory_triggered(stats: Dictionary)
signal undo_requested()
signal reset_requested()
signal next_level_requested()

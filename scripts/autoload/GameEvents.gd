extends Node

# Signals are used across the project to decouple components.
# They are emitted from various classes like Player.gd and Block.gd.

signal player_moved(from: Vector2i, to: Vector2i)
signal block_moved(block: Node2D, from: Vector2i, to: Vector2i)
signal win_condition_met()
signal level_generated(state: Dictionary)

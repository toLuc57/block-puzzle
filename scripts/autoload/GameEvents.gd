extends Node

signal player_moved(from: Vector2i, to: Vector2i)
signal block_moved(block: Node2D, from: Vector2i, to: Vector2i)
signal win_condition_met()
signal level_generated(state: Dictionary)

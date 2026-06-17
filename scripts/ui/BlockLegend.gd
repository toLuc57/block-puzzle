extends PanelContainer

@onready var hbox = %HBox

var block_resources = [
	preload("res://resources/blocks/gray_block.tres"),
	preload("res://resources/blocks/ice_block.tres")
]

func _ready():
	_setup_legend()

func _setup_legend():
	# Clear existing
	for child in hbox.get_children():
		child.queue_free()
		
	for data in block_resources:
		var item = HBoxContainer.new()
		item.add_theme_constant_override("separation", 10)
		
		# Icon (ColorRect as placeholder for Sprite)
		var icon = ColorRect.new()
		icon.custom_minimum_size = Vector2(20, 20)
		icon.color = data.color
		item.add_child(icon)
		
		# Description
		var label = Label.new()
		label.text = data.description
		label.add_theme_font_size_override("font_size", 12)
		item.add_child(label)
		
		hbox.add_child(item)

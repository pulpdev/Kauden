extends CanvasLayer
class_name UIOverworld

@onready var HpMin : Label = %HpMin
@onready var HpMax : Label = %HpMax

@export var target_sprite : Sprite2D
@export var command_menu : UICommandMenu

var player : Actor

func initialize(player : Actor)->void:
	if not player.is_in_group("PLAYER"):
		return

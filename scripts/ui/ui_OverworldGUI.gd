extends CanvasLayer
class_name UIOverworld

@export var target_sprite : Sprite2D
@export var command_menu : UICommandMenu

var player : Actor

func initialize(player : Actor)->void:
	if not player.is_in_group("PLAYER"):
		return

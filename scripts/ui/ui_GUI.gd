extends CanvasLayer

@onready var HpMin : Label = %HpMin
@onready var HpMax : Label = %HpMax

var player : Actor

func initialize(player : Actor)->void:
	if not player.is_in_group("PLAYER"):
		return

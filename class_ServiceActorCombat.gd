extends RefCounted
class_name SerivceActorCombat

var actor : Actor

func _init(actor : Actor) -> void:
	self.actor = actor

func is_attacking()->bool:
	return not actor._attack_timer.is_stopped()

func enable_damage_area()->void:
	pass

func disable_damage_area()->void:
	pass

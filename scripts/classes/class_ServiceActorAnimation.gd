extends RefCounted
class_name ServiceActorAnimation

var actor : Actor

func _init(actor : Actor) -> void:
	self.actor = actor
	
func play(animation : String, reset : bool = false)->void:
	actor._pivot.model.play_animation(animation, reset)

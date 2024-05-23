extends Action
class_name ActionMove

#func execute(params : Array = [])->void:
	#var actor = params[0]
	#var vector = params[1]
	#var speed = params[2]
	#var anim = params[3]
#
	#if vector:
		#var target : float = atan2(vector.x, vector.z)
		#actor.Pivot.move(target, actor.speed_turn)
#
	#actor.velocity.x = move_toward(actor.velocity.x, vector.x * speed, actor.friction)
	#actor.velocity.z = move_toward(actor.velocity.z, vector.z * speed, actor.friction)
	#actor.Pivot.Model.play_animation(anim)
#
	#actor.move_and_slide()
#
	#finished.emit()

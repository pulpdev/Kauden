extends Action
class_name ActionRun

func execute(params : Array = [])->void:
	var actor : Actor = params[0]
	var vector : Vector3 = params[1]
	var speed : float = params[2]

	if vector:
		var target : float = atan2(vector.x, vector.z)
		actor.Pivot.move(target, actor.speed_turn)

	actor.vector_move = vector * speed
	actor.Pivot.Model.play_animation(actor.data.anim_run)

	finished.emit()

extends Action
class_name ActionStand

func execute(params : Array = [])->void:
	var actor = params[0]
	actor.vector_move = Vector2.ZERO
	actor.Pivot.Model.play_animation(actor.data.anim_idle)

	finished.emit()

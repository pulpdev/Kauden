extends Action
class_name ActionAnimate

var actor : Actor

func execute(params : Array = [])->void:
	actor = params[0]
	var anim : String = params[1]
	actor.vector_move = Vector3.ZERO
	actor.Pivot.Model.Animations.animation_finished.connect(on_animation_finished)
	actor.Pivot.Model.play_animation(anim)

func on_animation_finished(anim : String)->void:
	actor.Pivot.Model.Animations.animation_finished.disconnect(on_animation_finished)
	actor = null
	finished.emit()

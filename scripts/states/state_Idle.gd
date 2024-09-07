#extends State
#
#func enter()->int:
	#if not controller.vector_input == Vector2.ZERO:
		#return EXIT
	#return RUN
#
#func process(delta)->int:
	#if enter() == EXIT:
		#return EXIT
	#controller.player.vector_move = Vector3.ZERO
	#controller.player.Pivot.Model.play_animation(controller.player.data.anim_idle)
	#return RUN

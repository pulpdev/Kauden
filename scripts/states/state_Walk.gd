#extends State
#
#var vector_input : Vector2
#
#func enter()->int:
	#vector_input = controller.vector_input
	#if vector_input == Vector2.ZERO:
		#return EXIT
	#else:
		#if controller.is_pressing_sprint():
			#return EXIT
	#return RUN
#
#func process(delta)->int:
	#if enter() == EXIT:
		#return EXIT
	#var vector_move : Vector3 = controller.SpringArm.calc_input_direction(vector_input)
	#var target : float = atan2(vector_move.x, vector_move.z)
	#controller.player.Pivot.move(target, controller.player.speed_turn)
	#controller.player.vector_move = vector_move * controller.player.data.speed_run
	#controller.player.Pivot.Model.play_animation(controller.player.data.anim_run)
	#return RUN

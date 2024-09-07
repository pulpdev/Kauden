extends Ability

func execute(params : Ability.AbilityParams = null)->void:
	super(params)
	var actor : Actor
	if params:
		actor = params.ability_actor
	actor.velocity = Vector3.ZERO
	var vector_move : Vector3
	var im : InputManager = actor.get_input_manager()
	var sa : SpringArm = actor.get_springarm()
	if not im.vector_input == Vector2.ZERO:
		vector_move = sa.calc_input_direction(im.vector_input)
	else:
		vector_move = actor.service_movement.get_model_direction()
	#actor.service_movement.tween_move(vector_move, 8.0, actor._attack_timer.wait_time / 2)
	#actor.service_animation.play("player_attack_01", true)
	actor.service_animation.play("bi_attack_gsword_04")

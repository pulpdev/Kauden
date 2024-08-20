extends Ability

func execute(params : Ability.AbilityParams = null)->void:
	super(params)
	var actor : Actor
	if params:
		actor = params.ability_actor
	actor.vector_move = Vector3.ZERO
	actor.controller.attack_delay.start()
	var vector_move : Vector3
	if actor.controller.target:
		vector_move = actor.eyes.get_look_vector_direction(actor.controller.target.get_target_position())
		actor.pivot.set_direction(vector_move)
	else:
		if not actor.controller.vector_input == Vector2.ZERO:
			vector_move = actor.controller.springarm.calc_input_direction(actor.controller.vector_input)
			actor.pivot.set_direction(actor.controller.vector_move)
		else:
			vector_move = actor.pivot.get_forward_direction()
	actor.tween_move(vector_move, 8.0, actor.controller.attack_delay.wait_time / 2, false)
	actor.pivot.model.play_animation("player_attack_01", true)
	finish()

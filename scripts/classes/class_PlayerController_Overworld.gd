extends PlayerController
class_name PlayerControllerOverworld

enum PlayerState {FREE, ATTACK, ACTION_STATIC, ACTION_DYNAMIC, CLIMB, HURT, DEATH}

var state : PlayerState = PlayerState.FREE

func _physics_process(delta: float) -> void:
	var im : InputManager = player.get_input_manager()
	var sa : SpringArm = player.get_springarm()

	if not im.vector_input == Vector2.ZERO:
		player._statemachine.try_state(StateMachine.StateFree)

	match im.control_scheme:
		InputManager.ControlScheme.KEYBOARD_MOUSE:
			im.vector_mouse.y = clamp(im.vector_mouse.y, deg_to_rad(sa.PITCH_MIN), deg_to_rad(sa.PITCH_MAX))
			sa.move(Vector3(im.vector_mouse.y, im.vector_mouse.x, 0))
		InputManager.ControlScheme.GAMEPAD:
			sa.move_add(Vector3(im.vector_joystick.y, im.vector_joystick.x, 0), delta)

func on_action_pressed(action)->void:
	if action.is_action_pressed("action_attack"):
		player._statemachine.try_state(StateMachine.StateAttack)

func on_control_scheme_changed(scheme : InputManager.ControlScheme)->void:
	var im : InputManager = player.get_input_manager()
	var sa : SpringArm = player.get_springarm()
	im.vector_mouse = sa.get_rotation_view()
	
func set_state(state : PlayerState)->void:
	var can_change : bool = false

	match self.state:
		PlayerState.FREE:
			can_change = true
		PlayerState.ATTACK:
			match state:
				PlayerState.FREE:
					if player._attack_timer.is_stopped():
						self.state = state
	
func manage_state()->void:
	pass

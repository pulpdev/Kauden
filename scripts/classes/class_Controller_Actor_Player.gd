extends ControllerActor
class_name ControllerPlayer

enum STATES {FREE, ATTACK, ACTION_STATIC, ACTION_DYNAMIC, CLIMB, HURT}

enum CONTROL_SCHEMES {
	KEYBOARD_MOUSE = 0,
	GAMEPAD = 1
}

const scene_menu_command := preload("res://abstract/scenes/ui/CommandMenu.tscn")

signal control_scheme_changed(scheme : int)
signal attack_pressed()

@export var springarm : SpringArm
@export var target_clear_delay : Timer
@export var target_sprite : Sprite2D
@export var party_positions : Node3D

var command_menu : Control
var vector_input : Vector2
var is_focusing : bool
var state : STATES = STATES.FREE
var target : Actor

func _ready():
	command_menu = scene_menu_command.instantiate()
	command_menu.command_pressed.connect(process_command_menu)
	add_child(command_menu)

func _input(event):
	if event is InputEventMouseMotion:
		springarm.control_scheme = springarm.CONTROL_SCHEMES.KEYBOARD_MOUSE
		var ex : float = event.relative.x
		var ey : float = event.relative.y
		springarm.vector_mouse.x += deg_to_rad(-event.relative.x) * springarm.sensitivity_mouse
		springarm.vector_mouse.y += deg_to_rad(event.relative.y) * springarm.sensitivity_mouse
		springarm.vector_mouse.y = clamp(springarm.vector_mouse.y, deg_to_rad(springarm.PITCH_MIN), deg_to_rad(springarm.PITCH_MAX))

	if event is InputEventJoypadMotion:
		springarm.control_scheme = springarm.CONTROL_SCHEMES.GAMEPAD
		if event.axis == 2:
			springarm.vector_joystick.x = -event.axis_value * springarm.sensitivity_joystick
		if event.axis == 3:
			springarm.vector_joystick.y = event.axis_value * springarm.sensitivity_joystick

	if event is InputEventKey:
		springarm.control_scheme = springarm.CONTROL_SCHEMES.KEYBOARD_MOUSE

	if event is InputEventJoypadButton:
		springarm.control_scheme = springarm.CONTROL_SCHEMES.GAMEPAD
	vector_input = Input.get_vector("action_left", "action_right", "action_up", "action_down")

	if Input.is_action_just_pressed("action_view_reset") and not is_focusing:
		springarm.view_reset(actor.pivot.global_rotation + Vector3(0.2,0,0))

func _process(delta):
	if target:
		is_focusing = true
		target_sprite.visible = true
		target_sprite.position = springarm.camera.unproject_position(target.get_target_position())
		var v1 = springarm.global_rotation
		springarm.look_at(target.global_position, Vector3.UP, true)
		var v2 = springarm.global_rotation
		springarm.global_rotation = v1
		springarm.move(v2, -12, 12)
		springarm.get_node("SpringArm3D").position.x = -0.5
		springarm.weight_camera.x = 8
		springarm.weight_camera.y = 8
	else:
		target_sprite.visible = false
		is_focusing = false
		springarm.get_node("SpringArm3D").position.x = 0.0
		springarm.weight_camera.x = 24
		springarm.weight_camera.y = 24
		match springarm.control_scheme:
			springarm.CONTROL_SCHEMES.GAMEPAD:
				if not springarm.vector_joystick == Vector2.ZERO:
					springarm.move_add(Vector3(springarm.vector_joystick.y, springarm.vector_joystick.x, 0), delta)
			CONTROL_SCHEMES.KEYBOARD_MOUSE:
				springarm.move(Vector3(springarm.vector_mouse.y, springarm.vector_mouse.x, 0))
		
	if Input.is_action_just_released("action_sprint"):
		sprint_delay.start()

	if is_pressed_focus():
		var t : TargetManager.Target = target_manager.target_find_distance_least(target_manager.targets)
		if t:
			target = t.target_actor

	if is_press_focus():
		if target_clear_delay.is_stopped():
			target_clear_delay.start()
			target_clear_delay.timeout.connect(on_target_clear_delay_timeout)
	else:
		if target_clear_delay.timeout.is_connected(on_target_clear_delay_timeout):
			target_clear_delay.timeout.disconnect(on_target_clear_delay_timeout)
		target_clear_delay.stop()

	process_state()

func process_state()->void:
	match state:
		STATES.FREE:
			actor.move(springarm.calc_input_direction(vector_input), actor.data.speed_run)
			if not vector_input == Vector2.ZERO:
				actor.pivot.model.play_animation(actor.data.anim_run)
			else:
				actor.pivot.model.play_animation(actor.data.anim_idle)
				
			if is_pressed_attack():
				attack_pressed.emit()
		STATES.ATTACK:
			if attack_delay.is_stopped():
				set_state(STATES.FREE)

func process_command_menu(command : int)->void:
	match command:
		0: pass
		1:
			if get_state() == STATES.FREE:
				if set_state(STATES.ATTACK) == true:
					attack()

func get_state()->STATES:
	if is_attacking():
		return STATES.ATTACK
	else:
		return STATES.FREE

func attack()->void:
	actor.vector_move = Vector3.ZERO
	attack_delay.start()
	var vector_move : Vector3
	if target:
		vector_move = actor.eyes.get_look_vector_direction(target.get_target_position())
		actor.pivot.set_direction(vector_move)
	else:
		if not vector_input == Vector2.ZERO:
			vector_move = springarm.calc_input_direction(vector_input)
			actor.pivot.set_direction(vector_move)
		else:
			vector_move = actor.pivot.get_forward_direction()
	actor.tween_move(vector_move, 8.0, attack_delay.wait_time / 2, false)
	actor.pivot.model.play_animation("player_attack_01", true)

func set_state(state : STATES)->bool:
	match state:
		STATES.ATTACK:
			if not attack_delay.is_stopped():
				return false
		STATES.FREE:
			if not attack_delay.is_stopped():
				return false
	self.state = state
	return true

func is_pressing_sprint()->bool:
	return Input.is_action_pressed("action_sprint")

func is_pressing_jump()->bool:
	return Input.is_action_pressed("action_jump")

func is_pressed_attack()->bool:
	return Input.is_action_just_pressed("action_attack")
	
func is_pressed_dodge()->bool:
	return Input.is_action_just_pressed("action_dodge")

func is_press_focus()->bool:
	return Input.is_action_pressed("action_focus")
	
func is_pressed_focus()->bool:
	return Input.is_action_just_pressed("action_focus")
	
func is_attacking()->bool:
	return not attack_delay.is_stopped()
	
func is_dodging()->bool:
	return not dodge_delay.is_stopped()

func get_party_positions()->Array[Vector3]:
	var a : Array[Vector3]
	for p in party_positions.get_children():
		a.append(p.global_position)
	return a

func on_target_clear_delay_timeout()->void:
	target = null
	springarm.vector_mouse = springarm.get_rotation_view()
	target_clear_delay.timeout.disconnect(on_target_clear_delay_timeout)

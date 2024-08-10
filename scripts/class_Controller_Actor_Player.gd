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

@export var SpringArm : SpringArm
@export var Camera : Camera3D
@export var TargetClearDelay : Timer
@export var TargetSprite : Sprite2D
@export var PartyPositions : Node3D
var CommandMenu : Control

var vector_view : Vector2
var vector_input : Vector2
var vector_joystick : Vector2
var sensitivity_mouse : float = 0.4
var sensitivity_joystick : float = 0.03
var control_scheme : CONTROL_SCHEMES = CONTROL_SCHEMES.KEYBOARD_MOUSE:
	set(x):
		if not control_scheme == x:
			control_scheme = x
			control_scheme_changed.emit(control_scheme)
var is_focusing : bool
var target_press_time : int
var state : STATES = STATES.FREE

func _ready():
	CommandMenu = scene_menu_command.instantiate()
	CommandMenu.command_pressed.connect(process_command_menu)
	add_child(CommandMenu)
	
	vector_view = SpringArm.get_rotation_view()

func _input(event):
	if event is InputEventMouseMotion:
		control_scheme = CONTROL_SCHEMES.KEYBOARD_MOUSE
		var ex : float = event.relative.x / 1
		var ey : float = event.relative.y / 1
		vector_view.x += deg_to_rad(-event.relative.x) * sensitivity_mouse
		vector_view.y += deg_to_rad(event.relative.y) * sensitivity_mouse
		vector_view.y = clamp(vector_view.y, deg_to_rad(SpringArm.PITCH_MIN), deg_to_rad(SpringArm.PITCH_MAX))

	if event is InputEventJoypadMotion:
		control_scheme = CONTROL_SCHEMES.GAMEPAD
		if event.axis == 2:
			vector_joystick.x = -event.axis_value * sensitivity_joystick
		if event.axis == 3:
			vector_joystick.y = event.axis_value * sensitivity_joystick

	if event is InputEventKey:
		control_scheme = CONTROL_SCHEMES.KEYBOARD_MOUSE

	if event is InputEventJoypadButton:
		control_scheme = CONTROL_SCHEMES.GAMEPAD

	vector_input = Input.get_vector("action_left", "action_right", "action_up", "action_down") 

func _process(delta):
	if target:
		is_focusing = true
		TargetSprite.visible = true
		TargetSprite.position = Camera.unproject_position(target.FocusPosition.global_position)
		#actor.Pivot.set_direction(actor.Eyes.get_look_vector_direction(target.global_position))
		SpringArm.move(actor.Eyes.get_look_vector_rotation(target.global_position))
		SpringArm.CameraPosition.rotation_degrees.x = -8
		SpringArm.get_node("SpringArm3D").position.y = 0.5
		SpringArm.get_node("SpringArm3D").position.x = -1


	else:
		TargetSprite.visible = false
		is_focusing = false
		match control_scheme:
			CONTROL_SCHEMES.GAMEPAD:
				SpringArm.move_add(Vector3(vector_joystick.y, vector_joystick.x, 0))
			CONTROL_SCHEMES.KEYBOARD_MOUSE:
				SpringArm.move(Vector3(vector_view.y, vector_view.x, 0))
		SpringArm.get_node("SpringArm3D").position.x = 0.0
		SpringArm.get_node("SpringArm3D").position.y = 0.0
		SpringArm.CameraPosition.rotation_degrees.x = 0

	if Input.is_action_just_released("action_sprint"):
		SprintDelay.start()

	if is_pressed_focus():
		target = find_closest_target()

	if is_press_focus():
		if TargetClearDelay.is_stopped():
			TargetClearDelay.start()
			TargetClearDelay.timeout.connect(on_TargetClearDelay_timeout)
	else:
		if TargetClearDelay.timeout.is_connected(on_TargetClearDelay_timeout):
			TargetClearDelay.timeout.disconnect(on_TargetClearDelay_timeout)
		TargetClearDelay.stop()
		
	process_state()

func process_state()->void:
	match state:
		STATES.FREE:
			if not vector_input == Vector2.ZERO:
				actor.move(SpringArm.calc_input_direction(vector_input), actor.data.speed_run)
				actor.Pivot.Model.play_animation(actor.data.anim_run)
			else:
				actor.move(Vector3.ZERO, 0.0)
				actor.Pivot.Model.play_animation(actor.data.anim_idle)
				
			if is_pressed_attack():
				attack_pressed.emit()
		STATES.ATTACK:
			if AttackDelay.is_stopped():
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
	AttackDelay.start()
	var vector_move : Vector3 = actor.Eyes.get_look_vector_direction(target.get_focus_position())
	if is_focusing and target:
		actor.Pivot.set_direction(vector_move)
	actor.tween_move(vector_move, 8.0, AttackDelay.wait_time / 2, not is_focusing)
	actor.Pivot.Model.play_animation("player_attack_01", true)

func set_state(state : STATES)->bool:
	match state:
		STATES.ATTACK:
			if not AttackDelay.is_stopped():
				return false
		STATES.FREE:
			if not AttackDelay.is_stopped():
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
	return not AttackDelay.is_stopped()
	
func is_dodging()->bool:
	return not DodgeDelay.is_stopped()

func find_closest_target()->Actor:
	if SpringArm.TargetArea.get_overlapping_bodies().size() > 0:
		var ts : Array = SpringArm.TargetArea.get_overlapping_bodies()
		for t in ts:
			if t == actor:
				ts.pop_at(ts.find(t))
		for t in ts:
			if t.is_in_group("PARTYMEMBER"):
				ts.pop_at(ts.find(t))
		if ts.size() == 0:
			return null
		var d : Dictionary
		for t in ts:
			if t.is_in_group("PARTYMEMBER"):
				ts.pop_at(ts.find(t))
		if ts.size() == 0:
			return null
		for t in ts:
			d[t] = t.global_position.distance_to(actor.global_position)
		ts.sort_custom(func(a,b): return d[a] < d[b])
		if not ts.front() == actor:
			return ts[0]
	return null

func get_party_positions()->Array[Vector3]:
	var a : Array[Vector3]
	for p in PartyPositions.get_children():
		a.append(p.global_position)
	return a

func on_TargetClearDelay_timeout()->void:
	target = null
	vector_view = SpringArm.get_rotation_view()
	TargetClearDelay.timeout.disconnect(on_TargetClearDelay_timeout)

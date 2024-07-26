extends ControllerActor
class_name ControllerPlayer

enum CONTROL_SCHEMES {
	KEYBOARD_MOUSE = 0,
	GAMEPAD = 1
}

signal control_scheme_changed(scheme : int)

@export var SpringArm : SpringArm
@export var Camera : Camera3D
@export var TargetClearDelay : Timer
@export var TargetSprite : Sprite2D
@export var PartyPositions : Node3D

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

	vector_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") 

func _process(delta):
	if target:
		is_focusing = true
		TargetSprite.visible = true
		TargetSprite.position = Camera.unproject_position(target.FocusPosition.global_position)
		actor.Pivot.set_direction(-actor.Eyes.get_look_vector_direction(target.global_position))

	else:
		TargetSprite.visible = false
		is_focusing = false

	match control_scheme:
		CONTROL_SCHEMES.GAMEPAD:
			SpringArm.add_pitch(vector_joystick.y)
			SpringArm.add_yaw(vector_joystick.x)
		CONTROL_SCHEMES.KEYBOARD_MOUSE:
			SpringArm.set_pitch(vector_view.y)
			SpringArm.set_yaw(vector_view.x)

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

func find_closest_target()->Actor:
	if SpringArm.TargetArea.get_overlapping_bodies().size() > 0:
		var ts : Array = SpringArm.TargetArea.get_overlapping_bodies()
		for t in ts:
			if t == actor:
				ts.pop_at(ts.find(t))
		if ts.size() == 0:
			return null
		var d : Dictionary
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
	TargetClearDelay.timeout.disconnect(on_TargetClearDelay_timeout)

extends ControllerActor
class_name ControllerPlayer

enum CONTROL_SCHEMES {
	KEYBOARD_MOUSE = 0,
	GAMEPAD = 1
}

signal control_scheme_changed(scheme : int)

@export var SpringArm : SpringArm

var vector_view : Vector2
var vector_input : Vector2
var vector_joystick : Vector2
var sensitivity_mouse : float = 0.5
var sensitivity_joystick : float = 0.02
var control_scheme : CONTROL_SCHEMES = CONTROL_SCHEMES.KEYBOARD_MOUSE:
	set(x):
		if not control_scheme == x:
			control_scheme = x
			control_scheme_changed.emit(control_scheme)

func initialize(player : Actor):
	self.player = player

func _input(event):
	if event is InputEventMouseMotion:
		control_scheme = CONTROL_SCHEMES.KEYBOARD_MOUSE
		vector_view.x += deg_to_rad(-event.relative.x)
		vector_view.y += deg_to_rad(event.relative.y)

	if event is InputEventJoypadMotion:
		control_scheme = CONTROL_SCHEMES.GAMEPAD
		if event.axis == 2:
			vector_joystick.x = -event.axis_value
		if event.axis == 3:
			vector_joystick.y = event.axis_value

	if event is InputEventKey:
		control_scheme = CONTROL_SCHEMES.KEYBOARD_MOUSE

	if event is InputEventJoypadButton:
		control_scheme = CONTROL_SCHEMES.GAMEPAD

	vector_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") 

func _process(delta):
	match control_scheme:
		CONTROL_SCHEMES.GAMEPAD:
			SpringArm.add_pitch(vector_joystick.y * sensitivity_joystick)
			SpringArm.add_yaw(vector_joystick.x * sensitivity_joystick)
		CONTROL_SCHEMES.KEYBOARD_MOUSE:
			SpringArm.set_pitch(vector_view.y * sensitivity_mouse)
			SpringArm.set_yaw(vector_view.x * sensitivity_mouse)

func is_pressing_sprint()->bool:
	return Input.is_action_pressed("action_sprint")

func is_pressing_jump()->bool:
	return Input.is_action_pressed("action_jump")

func is_pressed_attack()->bool:
	return Input.is_action_just_pressed("action_attack")

extends Node
class_name InputManager

enum CONTROL_SCHEMES {
	KEYBOARD_MOUSE = 0,
	GAMEPAD = 1
}

enum FOCUS_MODES {
	NONE = 0,
	STATIC = 1,
	DYNAMIC = 2
}

signal control_scheme_changed(scheme : CONTROL_SCHEMES)
signal focus_mode_changed(mode : FOCUS_MODES)
signal vector_mouse_changed(vector : Vector2)
signal vector_joystick_changed(vector : Vector2)
signal action_pressed(action : InputEventAction)

var enabled : bool
var vector_input : Vector2
var vector_mouse : Vector2
var vector_joystick : Vector2
var sensitivity_mouse : float = 0.1
var sensitivity_joystick : float = 0.03

var control_scheme : CONTROL_SCHEMES = CONTROL_SCHEMES.KEYBOARD_MOUSE:
	set = set_control_scheme

var focus_mode : FOCUS_MODES = FOCUS_MODES.NONE:
	set = set_focus_mode

func _input(event):
	if not enabled:
		return
	if event is InputEventMouseMotion:
		control_scheme = CONTROL_SCHEMES.KEYBOARD_MOUSE
		var ex : float = event.relative.x
		var ey : float = event.relative.y
		vector_mouse.x += deg_to_rad(-event.relative.x) * sensitivity_mouse
		vector_mouse.y += deg_to_rad(event.relative.y) * sensitivity_mouse
		vector_mouse_changed.emit(vector_mouse)

	if event is InputEventJoypadMotion:
		control_scheme = CONTROL_SCHEMES.GAMEPAD
		if event.axis == 2:
			vector_joystick.x = -event.axis_value * sensitivity_joystick
		if event.axis == 3:
			vector_joystick.y = event.axis_value * sensitivity_joystick
		vector_joystick_changed.emit(vector_joystick)

	if event is InputEventKey:
		control_scheme = CONTROL_SCHEMES.KEYBOARD_MOUSE

	if event is InputEventJoypadButton:
		control_scheme = CONTROL_SCHEMES.GAMEPAD

	if event is InputEventAction:
		vector_input = Input.get_vector("action_left", "action_right", "action_up", "action_down")
		action_pressed.emit(event)

func set_focus_mode(mode : FOCUS_MODES)->void:
	if not focus_mode == mode:
		focus_mode = mode
		focus_mode_changed.emit(focus_mode)
		
func set_control_scheme(scheme : CONTROL_SCHEMES)->void:
		if not control_scheme == scheme:
			control_scheme = scheme
			control_scheme_changed.emit(control_scheme)

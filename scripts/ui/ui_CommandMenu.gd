extends Control

enum COMMANDS {NONE, ATTACK, MAGIC, ITEM}

signal command_pressed(index : int)
signal command_selected(index : int)

@onready var Commands : Array[Button]

var selection : int

func _ready():
	for b in %list.get_children():
		Commands.append(b)
	Commands.front().grab_focus()

func _process(delta):
	if Input.is_action_just_pressed("action_command_down"):
		set_seleciton(selection + 1)
	if Input.is_action_just_pressed("action_command_up"):
		set_seleciton(selection - 1)
	if Input.is_action_just_pressed("action_attack"):
		get_selection(selection).pressed.emit()

func set_seleciton(index : int)->void:
	if index > Commands.size() - 1:
		index = 0
	elif index < 0:
		index = Commands.size() - 1
	selection = index
	command_selected.emit(selection)

func set_focus(index : int)->void:
	if index <= Commands.size() - 1:
		Commands[selection].grab_focus()

func button_add(button : Button)->void:
	%list.add_child(button)
	Commands.clear()
	for b in %list.get_children():
		Commands.append(b)

func get_selection(index :int)->Button:
	return Commands[index]
	
func on_command_pressed(command : COMMANDS)->void:
	command_pressed.emit(command)

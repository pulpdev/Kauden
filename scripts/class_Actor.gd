@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

enum FACTIONS {COMMON, HOSTILE, NEUTRAL}

const MIN_DIST_TO_LOCATION : float = 0.3
const FRICTION_DEFAULT : float = 0.2

@export var Controller : Controller
@export var Parameters : ParamManager
@export var data : ActorData
@export var Pivot : Pivot
@export var Eyes : Eyes

@onready var FocusPosition : Marker3D = $FocusPosition

var friction : float = FRICTION_DEFAULT
var vector_move : Vector3
var vector_move_last : Vector3
var speed : float

func _ready():
	if Controller:
		Controller.initialize(self)

func _physics_process(delta):
	velocity.x = vector_move.x
	velocity.z = vector_move.z

	if not is_on_floor():
		velocity.y += GameScene.gravity * GameScene.vector_gravity.y * delta
	else:
		velocity.y = 0.0
		
	move_and_slide()
	
	vector_move = lerp(vector_move, Vector3.ZERO, friction)
	
	if abs(vector_move.x) < 0.1:
		vector_move.x = 0.0
	if abs(vector_move.z) < 0.1:
		vector_move.z = 0.0

func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist
	
func get_focus_position()->Vector3:
	return FocusPosition.global_position

func is_moving()->bool:
	return not velocity == Vector3.ZERO

func move(vector : Vector3, speed : float, pivot_rotate : bool = true, friction : float = FRICTION_DEFAULT)->void:
	vector = vector.normalized()
	if pivot_rotate:
		Pivot.set_direction(vector)
	self.friction = friction
	self.speed = speed
	vector_move_last = vector * speed
	vector_move = vector_move_last
	
func tween_move(vector : Vector3, speed : float, duration : float, pivot_rotate : bool = true)->void:
	var t = create_tween()
	vector = vector.normalized()
	if pivot_rotate:
		Pivot.set_direction(vector)
	t.tween_property(self, "vector_move", vector * speed, duration)

func move_to_position(position : Vector3, pivot_rotate : bool = true, friciton : float = FRICTION_DEFAULT)->void:
	var destination : Vector3 = to_local(position)
	if global_position.distance_to(position) > 2.0:
		move(destination, data.speed_run, pivot_rotate, friction)
		Pivot.Model.play_animation(data.anim_run)
	elif global_position.distance_to(position) > 1.0:
		move(destination, data.speed_walk, pivot_rotate, friction)
		Pivot.Model.play_animation(data.anim_walk)

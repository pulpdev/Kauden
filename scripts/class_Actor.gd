@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

const MIN_DIST_TO_LOCATION : float = 1.1
const FRICTION_DEFAULT : float = 0.2

@export var Controller : Controller
@export var Parameters : ParamManager
@export var data : ActorData
@export var Pivot : Pivot
@export var Eyes : Eyes

var friction : float = FRICTION_DEFAULT
var vector_move : Vector3
var vector_move_last : Vector3

func _ready():
	if Controller:
		Controller.initialize(self)

func _physics_process(delta):
	velocity.x = lerp(velocity.x, vector_move.x, friction)
	velocity.z = lerp(velocity.z, vector_move.z, friction)
	vector_move.x = lerp(vector_move.x, 0.0, friction)
	vector_move.z = lerp(vector_move.z, 0.0, friction)
	if velocity.distance_to(Vector3.ZERO) < 0.1:
		velocity = Vector3.ZERO
		vector_move = Vector3.ZERO

	if is_on_floor():
		velocity.y = 0.0
	else:
		apply_gravity(GameScene.gravity, delta)

	move_and_slide()

func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func apply_gravity(gravity : float, delta : float)->void:
	velocity.y -= GameScene.gravity * delta

func is_moving()->bool:
	return not velocity == Vector3.ZERO

func move(vector : Vector3, speed : float, friction : float = FRICTION_DEFAULT)->void:
	Pivot.set_direction(vector)
	self.friction = friction
	vector_move_last = vector * speed
	vector_move = vector_move_last

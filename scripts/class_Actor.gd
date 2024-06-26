@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

enum FACTIONS {COMMON, HOSTILE, NEUTRAL}

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
var speed : float

func _ready():
	if Controller:
		Controller.initialize(self)

func _physics_process(delta):
	var destination : Vector3
	destination += vector_move

	velocity.x = destination.x
	velocity.z = destination.z
	
	if not is_on_floor():
		velocity.y += GameScene.gravity * GameScene.vector_gravity.y * delta
	else:
		velocity.y = 0.0

	
	move_and_slide()

	vector_move = lerp(vector_move, Vector3.ZERO, friction)


func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func is_moving()->bool:
	return not velocity == Vector3.ZERO

func move(vector : Vector3, speed : float, friction : float = FRICTION_DEFAULT)->void:
	vector = vector.normalized()
	Pivot.set_direction(vector)
	self.friction = friction
	self.speed = speed
	vector_move_last = vector * speed
	vector_move = vector_move_last


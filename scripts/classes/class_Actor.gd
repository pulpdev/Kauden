@icon("res://assets/editor/actor.svg")
extends CharacterBody3D
class_name Actor

enum FACTIONS {GOOD, EVIL, NEUTRAL}

const MIN_DIST_TO_LOCATION : float = 0.3
const FRICTION_DEFAULT : float = 20

@export var controller : ControllerActor
@export var stats : StatManager
@export var data : ActorData
@export var pivot : Pivot
@export var eyes : Eyes
@export var target_position : Marker3D
@export var faction : FACTIONS = FACTIONS.NEUTRAL

var friction : float = FRICTION_DEFAULT
var vector_move : Vector3
var speed : float

func _ready():
	if controller:
		controller.initialize(self)
	return

func _physics_process(delta):
	velocity.x = vector_move.x
	if not is_on_floor():
		velocity.y += GameScene.gravity * GameScene.vector_gravity.y * delta
	else:
		velocity.y = 0
	velocity.z = vector_move.z

	move_and_slide()
	
	vector_move = lerp(vector_move, Vector3.ZERO, friction * delta)
	
	if abs(vector_move.x) < 0.1:
		vector_move.x = 0.0
	if abs(vector_move.z) < 0.1:
		vector_move.z = 0.0

func is_near_position(pos : Vector3, min_dist : float = MIN_DIST_TO_LOCATION):
	return global_position.distance_to(pos) < min_dist

func get_target_position()->Vector3:
	if target_position:
		return target_position.global_position
	return Vector3.ZERO

func is_moving()->bool:
	return not velocity == Vector3.ZERO

func move(vector : Vector3, speed : float, pivot_rotate : bool = true, friction : float = FRICTION_DEFAULT)->void:
	vector = vector.normalized()
	if pivot_rotate:
		pivot.set_direction(vector)
	self.friction = friction
	self.speed = speed
	vector_move = vector * speed

func tween_move(vector : Vector3, speed : float, duration : float, pivot_rotate : bool = true)->void:
	var t = create_tween()
	vector = vector.normalized()
	if pivot_rotate:
		pivot.set_direction(vector)
	t.tween_property(self, "vector_move", vector * speed, duration)

func can_see_actor(actor : Actor)->bool:
	if controller:
		controller
	return true

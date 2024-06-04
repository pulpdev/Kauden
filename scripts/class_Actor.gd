extends CharacterBody3D
class_name Actor

const MIN_DIST_TO_LOCATION : float = 1.1

@export var Controller : Controller
@export var Parameters : ParamManager
@export var data : ActorData
@export var Pivot : Pivot
@export var Eyes : Eyes

var friction : float = 0.5
var speed_turn : float = 0.1
var vector_move : Vector3

func _ready():
	if Controller:
		Controller.initialize(self)

func _physics_process(delta):
	velocity.x = move_toward(velocity.x, vector_move.x, friction)
	velocity.z = move_toward(velocity.z, vector_move.z, friction)

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
	return abs(velocity) > Vector3.ZERO

func move(vector : Vector3, speed : float, animation : String)->void:
	if not vector == Vector3.ZERO:
		var target : float = atan2(vector.x, vector.z)
		Pivot.move(target, speed_turn)
	Pivot.Model.play_animation(animation)
	vector_move = vector * speed

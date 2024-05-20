extends Controller
class_name PlayerController

var player : Actor
var command_move : MoveCommand = MoveCommand.new()

func _init(player : Actor)->void:
	self.player = player

func _physics_process(delta):
	var vector : Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	command_move.execute(player, MoveCommand.Params.new(Vector3(-vector.x, 0.0, -vector.y), player.speed_move))

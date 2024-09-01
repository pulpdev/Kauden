extends GameMode
class_name  GameModeOverworld

const scene_menu_command := preload("res://abstract/scenes/ui/CommandMenu.tscn")

@export var actor_manager : ActorManager
@export var party : Party
@export var ui : UIOverworld
@export var player_controller : PlayerController

func _physics_process(delta):
	match actor_manager.player:
		null:
			pass
		_:
			var pc : ControllerPlayer = actor_manager.player.controller
			if pc:
				party.set_member_positions(actor_manager.player.controller.get_party_positions())

func initialize(scene : GameScene)->void:
	self.scene = scene
	if party:
		var actorlist : Array[Actor]
		var roster : Array[PackedScene] = party.get_roster()
		if roster.size() > 0:
			for a in roster:
				actorlist.append(actor_manager.actor_create(a))
			party.set_actor_list(actorlist)
			party.member_add(party.get_actor(0))
			party.member_add(party.get_actor(1))
			var pc : ControllerPlayer = actor_manager.get_player().Controller
			var positions : Array[Vector3] = pc.get_party_positions()
			actor_manager.actor_add(party.get_member(0), positions[0])
			actor_manager.actor_add(party.get_member(1), positions[1])
			
	if ui:
		ui.command_menu.command_selected.connect(ui.command_menu.set_focus)
		
	if player_controller:
		player_controller.initialize(actor_manager.get_player())

func on_party_member_add(actor : Actor)->void:
	actor

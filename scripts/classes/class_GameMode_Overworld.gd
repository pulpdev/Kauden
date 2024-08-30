extends GameMode
class_name  GameModeOverworld

const scene_menu_command := preload("res://abstract/scenes/ui/CommandMenu.tscn")

@export var ActorManager : ActorManager
@export var Party : Party
@export var ui : UIOverworld

var CommandMenu : Control

func _physics_process(delta):
	match ActorManager.player:
		null:
			pass
		_:
			var pc : ControllerPlayer = ActorManager.player.controller
			if pc:
				Party.set_member_positions(ActorManager.player.controller.get_party_positions())

func initialize(scene : GameScene)->void:
	self.scene = scene
	if Party:
		var actorlist : Array[Actor]
		var roster : Array[PackedScene] = Party.get_roster()
		if roster.size() > 0:
			for a in roster:
				actorlist.append(ActorManager.actor_create(a))
			Party.set_actor_list(actorlist)
			Party.member_add(Party.get_actor(0))
			Party.member_add(Party.get_actor(1))
			var pc : ControllerPlayer = ActorManager.get_player().Controller
			var positions : Array[Vector3] = pc.get_party_positions()
			ActorManager.actor_add(Party.get_member(0), positions[0])
			ActorManager.actor_add(Party.get_member(1), positions[1])
			
	if ui:
		ui.command_menu.command_selected.connect(ui.command_menu.set_focus)

	#var cm := scene_menu_command.instantiate()
	#add_child(cm)
	#cm.command_selected.connect(cm.set_focus)

func on_party_member_add(actor : Actor)->void:
	actor

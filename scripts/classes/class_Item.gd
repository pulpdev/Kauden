extends Resource
class_name Item

enum TYPES {FOOD, WEAPON, ARMOR, KEY}
enum PARAM_HEALS {NONE, HP, MP, AP}
enum TYPES_WEAPON {NONE, LONGSWORD, RAPIER, XBOW, SHIELD, STAFF}

@export var name : String
@export var icon : Texture2D
@export var type : TYPES
@export var type_weapon : TYPES_WEAPON = TYPES_WEAPON.NONE
@export var parameter_heal : PARAM_HEALS
@export var parameter_heal_amount : int
@export var stats : Dictionary = StatManager.STATS
@export var stack_size : int

func is_weapon()->bool:
	return type == TYPES.WEAPON and type_weapon > 0
	
func is_food()->bool:
	return type == TYPES.FOOD
	
func is_armor()->bool:
	return type == TYPES.ARMOR
	
func is_key()->bool:
	return type == TYPES.KEY

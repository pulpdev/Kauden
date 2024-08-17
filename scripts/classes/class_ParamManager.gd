extends Node
class_name StatManager

enum STATS {
	HP_MAX,
	TP_MAX,
	MP_MAX,
	AP_MAX,
	ATTACK,
	DEFENSE,
	CRITICAL
}

class Stat:
	extends Node
	const VALUE_MAX : int = 100

	signal base_changed(b)
	signal value_changed(v)

	@export_range(0, VALUE_MAX) var base : int:
		set(x):
			base = clamp(x, 0, VALUE_MAX)
			base_changed.emit(base)

	var value : int:
		set(x):
			value = clamp(x, 0, VALUE_MAX)
			value_changed.emit(value)
			
		get:
			return base + modifier_get_total()

	var modifiers : Array[int]
	
	func _init(name : String) -> void:
		self.name = name

	func modifier_get_total()->int:
		var bonus : int
		for modifier in modifiers:
			bonus += modifier
		return bonus
		
	func modifier_add(modifier : int)->void:
		modifiers.append(modifier)
		
	func modifier_remove(modifier : int)->void:
		for i in range(modifiers.size()):
			if modifiers[i] == modifier:
				modifiers.pop_at(i)

var hp : int :
	set(x):
		hp = clamp(x, 0, get_stat(STATS.HP_MAX).value)
var tp : int :
	set(x):
		hp = clamp(x, 0, get_stat(STATS.TP_MAX).value)
var mp : int :
	set(x):
		hp = clamp(x, 0, get_stat(STATS.MP_MAX).value)
var ap : int :
	set(x):
		hp = clamp(x, 0, get_stat(STATS.AP_MAX).value)

func get_stat(stat : int)->Stat:
	var s : Stat = get_node(STATS.keys()[stat])
	return s

func _ready() -> void:
	for s in STATS.keys():
		var stat : Stat = Stat.new(s)
		add_child(stat)
	get_stat(STATS.HP_MAX).value_changed.connect(func(v): hp = clamp(hp, 0, v))
	get_stat(STATS.MP_MAX).value_changed.connect(func(v): mp = clamp(mp, 0, v))
	get_stat(STATS.TP_MAX).value_changed.connect(func(v): tp = clamp(tp, 0, v))
	get_stat(STATS.AP_MAX).value_changed.connect(func(v): ap = clamp(ap, 0, v))
	

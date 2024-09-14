extends Condition
class_name ConditionItem

@export var item : int

func get_condition()->bool:
	return is_value_met(item)

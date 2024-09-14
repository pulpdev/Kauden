extends Condition
class_name ConditionVariable

@export var variable : int

func get_condition()->bool:
	return is_value_met(variable)

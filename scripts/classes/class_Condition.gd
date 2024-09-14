extends RefCounted
class_name Condition

enum Operands {
	EQUALS,
	NOT_EQUALS,
	GREATER_THAN,
	GREATER_EQUALS_THAN,
	LESS_THAN,
	LESS_EQUALS_THAN
}

@export_range(0, 999999) var value : int
@export var operand : Operands

func get_condition()->bool:
	return false

func is_value_met(value : int)->bool:
	match operand:
		Operands.EQUALS:
			return self.value == value
		Operands.NOT_EQUALS:
			return self.value != value
		Operands.GREATER_THAN:
			return self.value > value
		Operands.GREATER_EQUALS_THAN:
			return self.value >= value
		Operands.LESS_THAN:
			return self.value < value
		Operands.LESS_EQUALS_THAN:
			return self.value <= value
		_:
			return false

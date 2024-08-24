extends Resource
class_name ItemInventory

@export var items : Dictionary

func item_add(item)->void:
	if items.has(item):
		if not item.stack_size >= items[item]:
			items[item] += 1
	
func item_remove(item)->Item:
	if items.has(item):
		items[item] -= 1
		if items[item] <= 0:
			items.erase(item)
		return item
	return null
	
func item_has(item)->bool:
	return items.has(item)

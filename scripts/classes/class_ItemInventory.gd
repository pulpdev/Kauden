extends Resource
class_name ItemInventory

@export var items : Dictionary

func item_add(item)->void:
	if items.has(item):
		if item.size_stack >= items[item].size_stack:
			return
	items[item] += 1
	
func item_remove(item)->Object:
	if items.has(item):
		items[item] -= 1
		if items[item] <= 0:
			items.erase(item)
	return item
	
func item_has(item)->bool:
	return items.has(item)

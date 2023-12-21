extends Panel
## Used as a child of [InventoryContainer]
##
## Displays information about [InventoryItem] in hovered [InventorySlot]
class_name ItemInfo


@export_category("Node Control")
## [color=#9598a0]Displays [member InventoryItem.texture]
@export var texture_rect: TextureRect = null
## [color=#9598a0]Displays [member InventoryItem.name]
@export var name_label: Label = null
## [color=#9598a0]Displays [member InventoryItem.description]
@export var desc_label: Label = null


## [color=#9598a0]Updates itself and calls [method CanvasItem.show]
func popup(item: InventoryItem):
	if item:
		show()
		texture_rect.texture = item.texture
		name_label.text = item.name
		desc_label.text = item.description

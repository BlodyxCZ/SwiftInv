extends Resource
## An Inventory resource
class_name Inventory


## [color=#9598a0]After creatign new [Inventory] resource, define [member items] size in the inspector 
## (should match your [member InventoryContainer.backpack] + [member InventoryContainer.hotbar] amount of slots) [br]
## For example:
## [br]     for player, [code]Backpack 12 + Hotbar 5 -> items.size == 17[/code]
## [br]     for shops etc., [code]Backpack 20 + Hotbar 0 -> items size == 20[/code]
@export var items: Array[InventoryItem]

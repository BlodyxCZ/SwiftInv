extends Area2D
## A collectable [InventoryItem] for 2D
class_name Item2D

@export_category("Properties")
## [color=#9598a0]This [InventoryItem] will be given to a [PhysicsBody2D] with [InventoryCotainer]
## that colides with this [Item2D] [br] If [InventoryCotainer] is full, [Item2D] won't dissapear
## nor will be given to the [PhysicsBody2D]
@export var item: InventoryItem


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: PhysicsBody2D) -> void:
	for child in body.get_children(true):
		if child is InventoryContainer:
			var err = child.add_item(item)
			if err:
				return
			queue_free()

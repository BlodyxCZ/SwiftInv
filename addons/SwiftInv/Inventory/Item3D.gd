extends Area3D
## A collectable [InventoryItem] for 3D
class_name Item3D

@export_category("Properties")
## [color=#9598a0]This [InventoryItem] will be given to a [PhysicsBody3D] with [InventoryCotainer]
## that colides with this [Item3D] [br] If [InventoryCotainer] is full, [Item3D] won't dissapear
## nor will be given to the [PhysicsBody3D]
@export var item: InventoryItem


func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: PhysicsBody3D) -> void:
	for child in body.get_children():
		if child is InventoryContainer:
			var err = child.add_item(item)
			if err:
				return
			queue_free()

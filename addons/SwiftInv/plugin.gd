@tool
extends EditorPlugin


func _enter_tree():
	# Add custom types
	add_custom_type("Inventory", "Resource", preload("Inventory/Inventory.gd"), preload("Inventory/Icons/Inventory.svg"))
	add_custom_type("InventoryItem", "Resource", preload("Inventory/InventoryItem.gd"), preload("Inventory/Icons/InventoryItem.svg"))
	add_custom_type("InventoryContainer", "Control", preload("Inventory/InventoryContainer.gd"), preload("Inventory/Icons/InventoryContainer.svg"))
	add_custom_type("InventorySlot", "PanelContainer", preload("Inventory/InventoySlot.gd"), preload("Inventory/Icons/InventorySlot.svg"))
	add_custom_type("Item3D", "Area3D", preload("Inventory/Item3D.gd"), preload("Inventory/Icons/Item3D.svg"))
	add_custom_type("Item2D", "Area2D", preload("Inventory/Item2D.gd"), preload("Inventory/Icons/Item2D.svg"))
	add_custom_type("ItemInfo", "Panel", preload("Inventory/ItemInfo.gd"), preload("Inventory/Icons/ItemInfo.svg"))


func _exit_tree():
	# Remove custom types
	remove_custom_type("Inventory")
	remove_custom_type("InventoryItem")
	remove_custom_type("InventoryContainer")
	remove_custom_type("InventorySlot")
	remove_custom_type("Item3D")
	remove_custom_type("Item2D")
	remove_custom_type("ItemInfo")

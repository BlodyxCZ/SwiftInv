extends Control
## An Inventory Container with [InventorySlot]s.
##
## Can be used for player inventory, as well as NPC or shop inventories
class_name InventoryContainer


@export_category("Node Control")
## [color=#9598a0]Container with [InventorySlot]s that can't be selected
@export var backpack: GridContainer
## [color=#9598a0]Container with [InventorySlot]s that can be selected
@export var hotbar: GridContainer
## [color=#9598a0]Panel that pops up when [InventoryItem] in any [InventorySlot] is hovered,
## displaying it's info
@export var info_panel: ItemInfo

@export_category("Properties")
## [color=#9598a0]Inventory resource that will be used to store [InventoryItems]
## (make sure this resource is stored in the file system,
## and has correct [member Resource.resource_path] property)
@export var inventory: Inventory = null

@onready var _backpack_slots: Array = backpack.get_children() if backpack else Array()
@onready var _hotbar_slots: Array = hotbar.get_children() if hotbar else Array()

## [color=#9598a0]All slots contained in 
## [member hotbar] and [member backpack]
var slots : Array = Array()
## [color=#9598a0]Index of currently selected [InventorySlot] in the [member hotbar] container
@onready var selected: int = 0 if not _hotbar_slots == [] else null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_PASS
	_initiate_slots()
	_connect_signals()
	select(selected)


func _initiate_slots() -> void:
	slots.append_array(_hotbar_slots)
	slots.append_array(_backpack_slots)
	for i in inventory.items.size():
		slots[i].item = inventory.items[i]


func _connect_signals() -> void:
	for slot in slots:
		slot.slot_changed.connect(_refresh_inventory)
		slot.slot_hovered.connect(_refresh_info)


func _refresh_inventory() -> void:
	for i in inventory.items.size():
		inventory.items[i] = null
		inventory.items[i] = slots[i].item
	ResourceSaver.save(inventory)


func _refresh_info(info_item: InventoryItem, reset: bool) -> void:
	if reset:
		info_panel.hide()
		return
	info_panel.popup(info_item)


## [color=#9598a0]Adds [InventoryItem] to the inventory, if [InventoryItem]
## with the same name already exists, items will be stacked until
## [member InventoryItem.amount] is [member InventoryItem.max_stack],
## then a [method InventoryItem.instantiate] is called and added to an empty [InventorySlot] [br]
## Returns [constant @GlobalScope.OK] if item could be added,
## otherwise returns [constant @GlobalScope.FAILED]
func add_item(item: InventoryItem) -> Error:
	item = item.instantiate()
	for slot in slots:
		if slot.item and (slot.item.name == item.name and slot.item.amount < slot.item.max_stack):
			var combined = slot.item.amount + item.amount
			var overflow = combined - item.max_stack 
			if overflow > 0:
				var sec_item = item.instantiate()
				sec_item.amount = overflow
				add_item(sec_item)
				slot.item.amount = item.max_stack
			else:
				slot.item.amount = combined
			_refresh_inventory()
			return OK
	for slot in slots:
		if slot.item == null:
			slot.item = item
			_refresh_inventory()
			return OK
	printerr("Couldn't add item %s to inventory" % item.name)
	return FAILED


## [color=#9598a0]Empties the [member slots],
## making all [member InventorySlot.item]s [code]<null>[/code]
func clear() -> void:
	for slot in slots:
		slot.item = null
	_refresh_inventory()


## [color=#9598a0]Sets [InventoryItem] in [InventorySlot]
## at given index in [member slots]
func remove_by_index(index: int) -> Error:
	for i in inventory.items.size():
		if i == index:
			slots[i] = null
			_refresh_inventory()
			return OK
	printerr("Coudn't find item at index %d" % index)
	return FAILED


## [color=#9598a0]Select [member hotbar] [InventorySlot] with given index
func select(index: int) -> void:
	_selector(wrapi(index, 0, _hotbar_slots.size()))

## [color=#9598a0]Select next [member hotbar] [InventorySlot] [br]
## (tip: create with mouse_wheel_up InputEvent)
func select_next() -> void:
	_selector(wrapi(selected + 1, 0, _hotbar_slots.size()))

## [color=#9598a0]Select previous [member hotbar] [InventorySlot] [br]
## (tip: create mouse_wheel_down InputEvent)
func select_prev() -> void:
	_selector(wrapi(selected - 1, 0, _hotbar_slots.size()))

func _selector(value: int) -> void:
	slots[selected].frame.hide()
	selected = value
	slots[selected].frame.show()

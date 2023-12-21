extends PanelContainer
## Used as childs of [member InventoryContainer.backpack] or [member InventoryContainer.hotbar]
class_name InventorySlot


signal slot_changed()
signal slot_hovered(hovered_item, reset)

## [color=#9598a0]Currently displayed [InventoryItem]
var item: InventoryItem = null

@export_category("Node Control")
## [color=#9598a0]Frame is visible, if this slot is selected
@export var frame: Control = null
## [color=#9598a0]Displays [member InventoryItem.texture]
@export var texture_rect: TextureRect = null
## [color=#9598a0]Displays [member InventoryItem.amount]
@export var amount_label: Label = null
## [color=#9598a0]Time required for hovering over [InventorySlot] to show [InventoryInfo]
@export var timer: Timer = null

@export_category("Properties")
## [color=#9598a0]Size in pixels of drag preview
@export var drag_preview_size: int = 30


func _ready():
	frame.hide()
	_connect_signals()


func _connect_signals() -> void:
	if timer:
		timer.timeout.connect(func() -> void:
			slot_hovered.emit(item, false)
			)
	mouse_entered.connect(func() -> void:
		if timer and item:
			timer.start()
		)
	mouse_exited.connect(func() -> void:
		if timer:
			timer.stop()
			slot_hovered.emit(item, true)
		)


func _process(_delta) -> void:
	update_slot()


## [color=#9598a0]Updates [member texture_rect] and [member amount_label] [br]
## Called with [method Node._physics_process] by default
func update_slot() -> void:
	if item:
		texture_rect.texture = item.texture
		if item.amount > 1:
			amount_label.text = str(item.amount)
		else:
			amount_label.text = ""
	else:
		texture_rect.texture = null
		amount_label.text = ""


func _get_drag_data(at_position):
	if item:
		set_drag_preview(get_preview())
		var data = {}
		data["base_slot"] = self
		data["base_item"] = item
		return data


func _can_drop_data(at_position, data) -> bool:
	return data is Dictionary


func _drop_data(at_position, data) -> void:
	if not item or not data["base_item"].name == item.name or item.amount == item.max_stack:
		data["base_slot"].item = item
		item = data["base_item"]
	else:
		var combined = data["base_item"].amount + item.amount
		var overflow = combined - item.max_stack 
		if overflow > 0:
			data["base_item"].amount = overflow
			item.amount = item.max_stack
		else:
			data["base_slot"].item = null
			item.amount = combined
	slot_changed.emit()


func get_preview() -> Control:
	var preview_texture_rect = TextureRect.new()
	
	preview_texture_rect.texture = item.texture
	preview_texture_rect.expand_mode = 1
	preview_texture_rect.size = Vector2(drag_preview_size, drag_preview_size)
	preview_texture_rect.position = -preview_texture_rect.size / 2
	
	var preview = Control.new()
	preview.add_child(preview_texture_rect)
	
	return preview

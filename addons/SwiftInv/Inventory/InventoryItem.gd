extends Resource
## Can be stored in [Inventory]
class_name InventoryItem


## [color=#9598a0]Rarities for manipulating drop rates
enum Rarity {
	COMMON, ## [color=#9598a0] Recommended color: [color=#ffffff]#ffffff common
	UNCOMMON, ## [color=#9598a0] Recommended color: [color=#68de59]#68de59 uncommon
	RARE, ## [color=#9598a0] Recommended color: [color=#5e6ee2]#5e6ee2 rare
	EPIC, ## [color=#9598a0] Recommended color: [color=#de1ff6]#de1ff6 epic
	LEGENDARY, ## [color=#9598a0] Recommended color: [color=#ffc611]#ffc611 legendary
	MYTHIC, ## [color=#9598a0] Recommended color: [color=#ff033e]#ff033e mythic
}


## [color=#9598a0]Item types for better resource manipulation
enum Type {
	OTHER,
	WEAPON,
	ARMOR,
	CONSUMABLE,
	CURRENCY,
	QUEST,
}


@export_category("Properties")
## [color=#9598a0]Name is used to determine if [InventoryItem]s should stack or not on pickup
@export var name: String = ""
## [color=#9598a0]Can be seen in [ItemInfo] [br]
## (for shops, you can display item price here)
@export var description: String = ""
## [color=#9598a0]Price to use in shop containers
@export var price: int = 0
## [color=#9598a0]Texture for [InventorySlot]
@export var texture: Texture2D = null
@export_category("Enums")
## [color=#9598a0]Current rarity
@export var rarity: Rarity = Rarity.COMMON
## [color=#9598a0]Current type
@export var type: Type = Type.OTHER
@export_category("Count")
## [color=#9598a0]The amount of [InventoryItem] in [Inventory]
@export var amount: int = 1
## [color=#9598a0]Set to [code]1[/code] to make [InventoryItem] instackable
@export var max_stack: int = 24


## [color=#9598a0]Returns new copy of [InventoryItem] with same properties [br]
## (solves lots of duplicacy issues)
func instantiate() -> InventoryItem:
	var i = InventoryItem.new()
	i.name = name
	i.description = description
	i.price = price
	i.texture = texture
	i.rarity = rarity
	i.type = type
	i.amount = amount
	i.max_stack = max_stack
	return i

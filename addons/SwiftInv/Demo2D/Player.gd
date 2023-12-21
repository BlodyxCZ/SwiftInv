extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta) -> void:
	_handle_movement(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if not $PlayerInventory/Backpack.visible:
			$PlayerInventory/Backpack.show()
		else:
			$PlayerInventory/Backpack.hide()
	if Input.is_action_just_pressed("ui_page_up"):
		$PlayerInventory.select_next()
	if Input.is_action_just_pressed("ui_page_down"):
		$PlayerInventory.select_prev()


func _handle_movement(delta) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

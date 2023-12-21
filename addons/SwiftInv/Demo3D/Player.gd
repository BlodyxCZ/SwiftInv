extends CharacterBody3D


const SPEED : float = 5.0
const JUMP_VELOCITY : float = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var mouse_sensitivity : float = 0.2

@onready var spring_arm = $SpringArm3D


func _physics_process(delta) -> void:
	_handle_movement(delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			$PlayerInventory/backpack.show()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			$PlayerInventory/backpack.hide()
	if Input.is_action_just_pressed("ui_page_up"):
		$PlayerInventory.select_next()
	if Input.is_action_just_pressed("ui_page_down"):
		$PlayerInventory.select_prev()


func _handle_movement(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized().rotated(Vector3.UP, spring_arm.rotation.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion and not $PlayerInventory/backpack.visible:
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x - event.relative.y * mouse_sensitivity, -88.0, 88.0)
		spring_arm.rotation_degrees.y = wrap(spring_arm.rotation_degrees.y - event.relative.x * mouse_sensitivity, 0.0, 360.0)


func _on_button_pressed():
	$PlayerInventory.clear()

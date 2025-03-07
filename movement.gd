extends CharacterBody3D


const SPEED = 15
const JUMP_VELOCITY = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var animation = $AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			
			rotation.y = -event.relative.y * 0.01
			camera.rotate_x(-event.relative.y * 0.01)
			rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-30), deg_to_rad(60))

func _ready():
	pass
func _on_timer_timeout():
	print("Time to attack!")
	$CollisionShape3D.disabled = false
func _physics_process(delta):
	# Add the gravity.
	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("shift"):
		gravity = gravity * 10
	if Input.is_action_just_pressed("dodge"):
		$Timer.start()
		$CollisionShape3D.disabled = true
		animation.play("flip")	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	if Input.is_action_just_pressed("ui_accept") and not is_on_floor():
		velocity.y = JUMP_VELOCITY * 2
		gravity = gravity * 2
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

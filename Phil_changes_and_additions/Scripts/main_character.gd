extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Player Functions
func _physics_process(delta):
	#Animation
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "Running"
	else:
		sprite_2d.animation = "Idle"

	#Allows player to drop through the platforms
	if Input.is_action_just_pressed("Down") and is_on_floor():
		position.y += 2
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "Jumping"

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	#Quits game
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	#Flips the characters direction depending on what direction you move in
	var isleft = velocity.x < 0
	sprite_2d.flip_h = isleft

extends CharacterBody2D

class_name player



const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyoteTimeChangeable = 10
var coyoteTimer = coyoteTimeChangeable
var jumpable = false
var isSliding = false
var impulseForce = 1000
var velocityCalc
var slid = false
var GroundedOnce = false
var slideSpeed = false
var firstSlideFrame = false
var leftKeyPressed = false
var rightKeyPressed = false





func lie_down(dir):

	#declan says hi
	if dir == 1:
		$AnimatedSprite2D.animation = "Sliding_left"
		isSliding = true
		
	elif dir == -1:
		$AnimatedSprite2D.animation = "Sliding_right"
		isSliding = true
		
func stand_up(flip):
		# Flip the character back to standing position

		if flip == 1:
			$AnimatedSprite2D.animation = "idle_left"

		else:
			$AnimatedSprite2D.animation = "idle"

			
		isSliding = false
		
		if leftKeyPressed:
			$AnimatedSprite2D.animation = "run_left"

		elif rightKeyPressed:
			$AnimatedSprite2D.animation = "Running"

func _ready():
	Engine.max_fps = 60  # Set your desired FPS cap here




func _physics_process(delta):
	#assign the vector2 function to a variable used to flip

	var isGrounded = is_on_floor()
	if isGrounded:
		GroundedOnce = true
	var dir: int = int(sign(velocity.x))
	
	
	if not isGrounded && coyoteTimer:
		coyoteTimer -= 1
		jumpable = true
	elif not isGrounded:
		jumpable = false
	elif isGrounded:
		isGrounded = true
		coyoteTimer = coyoteTimeChangeable
		jumpable = true
		
		
	# Add the gravity.
	if not isGrounded:
		if GroundedOnce:
			gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
			GroundedOnce = false
		gravity += 20
		velocity.y += gravity * delta
		
	
	
	# Handle Jump.

	if Input.is_action_just_pressed("jump") and jumpable:
		velocity.y = JUMP_VELOCITY
		coyoteTimer = 0	
		
		
	if Input.is_action_just_pressed("slide"):
		slid = true;
		firstSlideFrame = true;
		if dir == 1:
			lie_down(-1)			
		elif dir == -1:
			lie_down(1)
			
	if Input.is_action_just_released("slide"):
		stand_up(dir)

	if Input.is_action_just_pressed("left"):
		leftKeyPressed = true
		$AnimatedSprite2D.animation = "run_left"

		
	if Input.is_action_just_released("left"):
		leftKeyPressed = false
		stand_up(1)
		
	if Input.is_action_just_pressed("right"):
		$AnimatedSprite2D.animation = "Running"
		rightKeyPressed = true
		
	if Input.is_action_just_released("right"):
		rightKeyPressed = false
		stand_up(-1)
		
	
	
	
	

		
		
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")

	if velocity.x > 351 && direction or velocity.x < -351 && direction:
		firstSlideFrame = false
		velocity.x = lerp(velocity.x, 0.0, 0.05)				
	elif direction != 0:
		# Apply sliding adjustment
		if isSliding && slid && firstSlideFrame == true:
			
			firstSlideFrame = false			
			if direction == 1:
				velocity.x =  1000
			if direction == -1:
				velocity.x =  -1000
				slideSpeed = true	
				print_debug("reached here")
			slid = false
			firstSlideFrame = false
		else:
			velocity.x = direction * SPEED
			firstSlideFrame = false
				
	else:
		firstSlideFrame = false
		# Apply smooth deceleration using lerp
		velocity.x = lerp(velocity.x, 0.0, 0.05)
	



	
	move_and_slide()
	




func _on_area_2d_2_body_entered(body):
	print_debug("body ")
	if body.is_in_group("Finish") == true:
		print_debug("the body group entered")
	

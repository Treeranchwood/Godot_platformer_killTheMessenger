extends RigidBody2D

var go

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("slide"):
		

	if Input.is_action_just_pressed("left"):
		print_debug("rb2d left")

	if Input.is_action_just_pressed("right"):
		print_debug("rb2d right")


	

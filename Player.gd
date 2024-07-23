extends CharacterBody2D

const SPEED = 300.0

@onready var anim = get_node("AnimationPlayer")
func _ready():
	anim.play("Idle")

func _physics_process(delta):
	# Add the gravity.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * SPEED
	if velocity.x > 0: 
		anim.play("Walk_Right")
	elif velocity.x < 0: 
		anim.play("Walk_Left")
	elif velocity.y > 0: 
		anim.play("Walk_Down")
	elif velocity.y < 0: 
		anim.play("Walk_Up")
	else:
		anim.play("Idle")

	move_and_slide()

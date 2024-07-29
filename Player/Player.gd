extends CharacterBody2D

const SPEED = 100.0

@onready var anim = get_node("AnimationPlayer")
func _ready():
	anim.play("Idle")

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * SPEED
	if velocity.x > 0: 
		get_node("AnimatedSprite2D").flip_h = false
		anim.play("Walk")
	elif velocity.x < 0: 
		get_node("AnimatedSprite2D").flip_h = true
		anim.play("Walk")
	elif velocity.y > 0: 
		anim.play("Walk")
	elif velocity.y < 0: 
		anim.play("Walk")
	else:
		anim.play("Idle")

	move_and_slide()

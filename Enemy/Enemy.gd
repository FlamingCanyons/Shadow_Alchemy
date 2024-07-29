extends AnimatedSprite2D

const SPEED = 100.0
var newSpeed = 10


@onready var anim = $"../AnimationPlayer"
@onready var animatedSprite = 
@onready var ray_cast_left = $"../RayCastLeft"
@onready var ray_cast_right = $"../RayCastRight"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var SPEED = 50
	var direction = 1
	

	
	if ray_cast_left.is_colliding():
		direction = 1
	elif ray_cast_right.is_colliding():
		direction = -1
	newSpeed = direction * SPEED * delta
	position.x += newSpeed
	
	if newSpeed > 0:
		get_node("AnimatedSprite2D").flip_h = true
		anim.play("Walk")
	elif newSpeed < 0:
		get_node("AnimatedSprite2D").flip_h = false
		anim.play("Walk")


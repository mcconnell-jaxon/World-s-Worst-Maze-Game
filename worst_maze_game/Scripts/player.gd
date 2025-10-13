extends CharacterBody2D


@export var SPEED = 200.0
@onready var sprite = $AnimatedSprite2D

func get_input():
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	
func animation_handler():
	if velocity.x < 0:
		sprite.play("left")
	elif velocity.x > 0:
		sprite.play("right")
	elif velocity.y < 0:
		sprite.play("up")
	elif velocity.y > 0:
		sprite.play("down")
	else:
		sprite.stop()
		
func sprint_handler():
	#modify speed for sprinting
	if Input.is_action_pressed("Sprint"):
		SPEED = 400
		sprite.speed_scale = 2
	else:
		SPEED = 200
		sprite.speed_scale = 1
		
func _ready():
	sprite.stop()
	
func _physics_process(_delta):
	get_input()
	sprint_handler()
	animation_handler()
	move_and_slide()

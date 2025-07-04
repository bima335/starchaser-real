extends CharacterBody2D

const GRAVITY : int = 2800
const JUMP_SPEED : int = -1200
var barrier_scene = preload("res://Scenes/barrier.tscn")
var barrier_instance = null
var has_barrier: bool = false
#@onready var barrier = $Barrier
var q_just_pressed = false
var q_just_released := true

func _physics_process(delta):
	velocity.y += GRAVITY*delta
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_SPEED
			$JumpAudio.play()
			$AnimatedSprite2D.play("Jump")
		else:
			$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Float")
	move_and_slide()

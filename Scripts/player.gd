extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1000

func _physics_process(delta):
	velocity.y += GRAVITY*delta
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_SPEED
			$JumpAudio.play()
		else:
			$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Jump")
	move_and_slide()

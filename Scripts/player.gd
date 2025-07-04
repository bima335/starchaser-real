extends CharacterBody2D

const GRAVITY : int = 2800
const JUMP_SPEED : int = -1200

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

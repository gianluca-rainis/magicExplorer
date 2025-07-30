extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		
	if input_vector.x != 0:
		if input_vector.x < 0:
			$AnimatedSprite2D.play("runSide")
		else:
			$AnimatedSprite2D.play("runSide")
	elif input_vector.y != 0:
		if input_vector.y < 0:
			$AnimatedSprite2D.play("runBack")
		else:
			$AnimatedSprite2D.play("runFrontal")
	else:
		$AnimatedSprite2D.play("default")
	
	
	velocity = input_vector * SPEED

	move_and_slide()

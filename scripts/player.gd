extends CharacterBody2D

signal hit

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
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.play("runSide")
			$AnimatedSprite2D.flip_h = false
	elif input_vector.y != 0:
		if input_vector.y < 0:
			$AnimatedSprite2D.play("runBack")
		else:
			$AnimatedSprite2D.play("runFrontal")
	else:
		$AnimatedSprite2D.play("default")
	
	
	velocity = input_vector * Global.SPEED

	move_and_slide() # Move the player and get the collisions
	
	var collision = get_last_slide_collision()
	
	if collision:
		if collision.get_collider() is CharacterBody2D:
			hit.emit()

extends CharacterBody2D

var player: Node2D

var pv = Global.goblinPv 
var damage = Global.goblinDamage
var scoreAtKill = Global.goblinScore

signal enemyKilled(points)

func _physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		
		if direction.x != 0:
			if direction.x < 0:
				$AnimatedSprite2D.play("runSide")
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.play("runSide")
				$AnimatedSprite2D.flip_h = false
		elif direction.y != 0:
			if direction.y < 0:
				$AnimatedSprite2D.play("runBack")
			else:
				$AnimatedSprite2D.play("runFrontal")
		else:
			$AnimatedSprite2D.play("default")
			
		velocity = direction * Global.goblinSpeed
	
	move_and_slide()

func take_damage(damage):
	pv -= damage
	if pv <= 0:
		die()

func die(): # The enemy die
	emit_signal("enemyKilled", scoreAtKill)
	queue_free()

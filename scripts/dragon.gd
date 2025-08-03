extends CharacterBody2D

var player: Node2D

var pv = Global.dragonPv 
var damage = Global.dragonDamage
var scoreAtKill = Global.dragonScore

var knockback_velocity := Vector2.ZERO
var knockback_time := 0.2
var knockback_timer := 0.0

var roomName = ""

signal enemyKilled(points: int, room: String)

func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
	else:
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

func apply_knockback(direction: Vector2, speed: int) -> void: # Knocked when hitten
	knockback_velocity = direction.normalized() * speed
	knockback_timer = knockback_time

func die(): # The enemy die
	emit_signal("enemyKilled", scoreAtKill, roomName)
	queue_free()

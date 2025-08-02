extends CharacterBody2D

signal hit

@export var fireboltScene: PackedScene
@export var airwallScene: PackedScene
@export var waterTrapScene: PackedScene

var canMove = false
var canCastMagic = false
var fireboltLaunched = false
var airWallLaunched = false
var waterTrapLaunched = false

var last_move_direction: Vector2 = Vector2.RIGHT
@onready var fireboltRechargeTimer = Timer.new()
@onready var airwallRechargeTimer = Timer.new()
@onready var waterTrapRechargeTimer = Timer.new()

func _ready() -> void:
	add_child(fireboltRechargeTimer)
	fireboltRechargeTimer.wait_time = Global.fireBoltLifeTime
	fireboltRechargeTimer.one_shot = true
	fireboltRechargeTimer.connect("timeout", Callable(self, "_on_firebolt_recharged"))
	
	add_child(airwallRechargeTimer)
	airwallRechargeTimer.wait_time = Global.airWallLifeTime
	airwallRechargeTimer.one_shot = true
	airwallRechargeTimer.connect("timeout", Callable(self, "_on_airwall_recharged"))
	
	add_child(waterTrapRechargeTimer)
	waterTrapRechargeTimer.wait_time = Global.waterTrapLifeTime
	waterTrapRechargeTimer.one_shot = true
	waterTrapRechargeTimer.connect("timeout", Callable(self, "_on_waterTrap_recharged"))

func _physics_process(delta: float) -> void:
	if canMove:
		# Get the input direction and handle the movement/deceleration.
		var input_vector = Vector2.ZERO
		
		input_vector.x = Input.get_axis("ui_left", "ui_right")
		input_vector.y = Input.get_axis("ui_up", "ui_down")
		
		if input_vector != Vector2.ZERO:
			input_vector = input_vector.normalized()
			last_move_direction = input_vector
			
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
				getDamage(collision.get_collider())
	else:
		$AnimatedSprite2D.play("default")

func _unhandled_input(event):
	if event.is_action_pressed("castMagic1"):  # Project > InputMap > castMagic1
		launch_firebolt()
	elif event.is_action_pressed("castMagic2"):
		launch_waterTrap()
	elif event.is_action_pressed("castMagic3"):
		launch_airwall()

func launch_firebolt():
	if not fireboltLaunched and canCastMagic:
		var firebolt = fireboltScene.instantiate()
		
		firebolt.add_to_group("magics")
		firebolt.position = position + last_move_direction * 50
		firebolt.direction = last_move_direction.normalized()
		
		get_parent().add_child(firebolt)
		
		fireboltLaunched = true
		fireboltRechargeTimer.start()
		
func _on_firebolt_recharged():
	fireboltLaunched = false

func launch_airwall():
	if not airWallLaunched and canCastMagic:
		var airWall = airwallScene.instantiate()
		
		airWall.add_to_group("magics")
		airWall.position = position + last_move_direction * 50
		airWall.direction = last_move_direction.normalized()
		
		get_parent().add_child(airWall)
		
		airWallLaunched = true
		airwallRechargeTimer.start()
		
func _on_airwall_recharged():
	airWallLaunched = false
	
func launch_waterTrap():
	if not waterTrapLaunched and canCastMagic:
		var waterTrap = waterTrapScene.instantiate()
		
		waterTrap.add_to_group("magics")
		waterTrap.position = position + last_move_direction * 50
		waterTrap.direction = last_move_direction.normalized()
		
		get_parent().add_child(waterTrap)
		
		waterTrapLaunched = true
		waterTrapRechargeTimer.start()
		
func _on_waterTrap_recharged():
	waterTrapLaunched = false

func getDamage(enemy):
	hit.emit(enemy.damage)

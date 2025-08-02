extends Area2D

var speed = Global.waterTrapSpeed
var damage = Global.waterTrapDamage
var knockSpeed = Global.waterTrapKnockSpeed
var direction: Vector2 = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Animation.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		
		if "apply_knockback" in body:
			body.apply_knockback(direction, knockSpeed)
		queue_free()

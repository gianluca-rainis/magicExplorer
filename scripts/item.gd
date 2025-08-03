extends Area2D

@export var item_type: String
@export var item_id: String

func _ready():
	if Global.collected_items.get(item_id, false):
		queue_free()
	else:
		$CollisionShape2D.disabled = true
		await get_tree().create_timer(0.3).timeout
		$CollisionShape2D.disabled = false
		
		connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player":
		if item_type == "heart":
			Global.maxPv += 1
		elif item_type == "power":
			var randomPower = randi_range(0, 2)
			
			if randomPower == 0:
				Global.fireBoltSpeed += 100.0
				Global.fireBoltDamage += 1
				Global.fireBoltLifeTime -= 0.25
				Global.fireBoltKnockSpeed += 100
			elif randomPower == 1:
				Global.airWallSpeed += 150.0
				Global.airWallDamage += 0.5
				Global.airWallLifeTime -= 0.5
				Global.airWallKnockSpeed += 350
			elif randomPower == 2:
				Global.waterTrapSpeed += 0.0
				Global.waterTrapDamage += 0.5
				Global.waterTrapLifeTime -= 1.0
				Global.waterTrapKnockSpeed += 200

		Global.collected_items[item_id] = true
		queue_free()

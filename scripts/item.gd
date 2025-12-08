extends Area2D

signal firebolt_levelup
signal airwall_levelup
signal watertrap_levelup

@export var item_type: String
@export var item_id: String

func _ready():
	add_to_group("items")
	
	if Global.collected_items.get(item_id, false):
		queue_free()
	else:
		$CollisionShape2D.disabled = true
		await get_tree().create_timer(0.3).timeout
		$CollisionShape2D.disabled = false
		
		connect("body_entered", Callable(self, "_on_body_entered"))
	
	var main = get_tree().get_first_node_in_group("main")
	if main:
		main._connect_item_signals(self)

func _on_body_entered(body):
	if body.name == "player":
		if item_type == "heart":
			Global.maxPv += 1
		elif item_type == "power":
			var randomPower = randi_range(0, 2)
			
			if randomPower == 0:
				Global.fireBoltLevel += 1
				Global.fireBoltSpeed += 100.0
				Global.fireBoltDamage += 1
				
				if Global.fireBoltLifeTime > 0:
					Global.fireBoltLifeTime -= 0.25
					
					if Global.fireBoltLifeTime < 0:
						Global.fireBoltLifeTime = 0
				
				Global.fireBoltKnockSpeed += 100
				
				emit_signal("firebolt_levelup")
			elif randomPower == 1:
				Global.airWallLevel += 1
				Global.airWallSpeed += 150.0
				Global.airWallDamage += 0.5
				
				if Global.airWallLifeTime > 0:
					Global.airWallLifeTime -= 0.5
					
					if Global.airWallLifeTime < 0:
						Global.airWallLifeTime = 0
				
				Global.airWallKnockSpeed += 350
				
				emit_signal("airwall_levelup")
			elif randomPower == 2:
				Global.waterTrapLevel += 1
				Global.waterTrapSpeed += 0.0
				Global.waterTrapDamage += 0.5
				
				if Global.waterTrapLifeTime > 0:
					Global.waterTrapLifeTime -= 1.0
					
					if Global.waterTrapLifeTime < 0:
						Global.waterTrapLifeTime = 0
				
				Global.waterTrapKnockSpeed += 200
				emit_signal("watertrap_levelup")

		Global.collected_items[item_id] = true
		queue_free()

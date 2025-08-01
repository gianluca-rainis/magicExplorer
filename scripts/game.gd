extends Node2D

@export var enemyScenes: Array[PackedScene]
var score = 0
var pv = Global.maxPv

var isGameOver = false
var wasHit = false

var hearths: Array[TextureRect] = []
@onready var containter = $HearthsContainer
var hearthsTexture = preload("res://images/main/hearth.png")

func _ready() -> void: # First execution
	for i in range(Global.maxPv):
		var heart = TextureRect.new()
		heart.texture = hearthsTexture
		heart.custom_minimum_size = Vector2(32, 32)
		heart.expand = true
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearths.append(heart)
		containter.add_child(heart)

func _process(delta: float) -> void: # Each frame
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if isGameOver and event.is_pressed():
		_restart_game()

func _on_enemy_timer_timeout() -> void: # On end enemyTimer
	if not get_tree().get_nodes_in_group("enemies") or get_tree().get_nodes_in_group("enemies").size() < 10:
		var enemyScene = enemyScenes.pick_random()
		
		var enemyIstance = enemyScene.instantiate()
	
		enemyIstance.position = Vector2(576, 150)
		enemyIstance.player = $player
		
		if enemyIstance.name == "BlueGoblin":
			enemyIstance.position.y = 400
		
		enemyIstance.add_to_group("enemies")
		add_child(enemyIstance)
	
func _on_score_timer_timeout() -> void: # On end scoreTimer
	score += randi_range(250, 400)
	$HeadUpDisplay/Score.text = str(score)

func _on_player_hit(damage) -> void: # When a player hit an enemy
	if not wasHit:
		wasHit = true
		pv -= damage
		
		for i in range(damage):
			if hearths.size() > 0:
				var last_heart = hearths.pop_back()
				containter.remove_child(last_heart)
				last_heart.queue_free()
			else:
				break
		
		_controlGameOver()
		
		await get_tree().create_timer(3).timeout
		wasHit = false

func _controlGameOver() -> void:
	if pv <= 0:
		$HeadUpDisplay/FinalMessage.show()
		$HeadUpDisplay/FinalScore.text = "Your Score: " + str(score)
		$HeadUpDisplay/FinalScore.show()
		$HeadUpDisplay/Score.hide()
		
		$scoreTimer.stop()
		$enemyTimer.stop()
		
		$player.canMove = false
		$player.canCastMagic = false
		$background.texture = preload("res://images/background/black.png")
		$TileMapLayer.clear()
		$player.position = Vector2(576, 400)
		
		for magic in get_tree().get_nodes_in_group("magics"):
			magic.queue_free()
		
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()
		
		wasHit = true
		
		await get_tree().create_timer(1).timeout
		isGameOver = true

func _restart_game():
	get_tree().reload_current_scene()

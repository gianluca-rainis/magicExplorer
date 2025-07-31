extends Node2D

@export var enemyScenes: Array[PackedScene]
var score = 0
var pv = Global.maxPv

var wasHitten = false

var hearths: Array[TextureRect] = []
@onready var containter = $HearthsContainer
var hearthsTexture = preload("res://images/main/hearth.png")

func _ready() -> void: # First execution
	for i in Global.maxPv:
		var heart = TextureRect.new()
		heart.texture = hearthsTexture
		heart.custom_minimum_size = Vector2(32, 32)
		heart.expand = true
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearths.append(heart)
		containter.add_child(heart)

func _process(delta: float) -> void: # Each frame
	pass

func _on_enemy_timer_timeout() -> void: # On end enemyTimer
	var enemyScene = enemyScenes.pick_random()
	
	var enemyIstance = enemyScene.instantiate()
	
	enemyIstance.position = Vector2(576, 150)
	
	if enemyIstance.name == "BlueGoblin":
		enemyIstance.position.y = 400
	
	add_child(enemyIstance)
	
func _on_score_timer_timeout() -> void: # On end scoreTimer
	score += randi_range(250, 400)
	$HeadUpDisplay/Score.text = str(score)

func _on_player_hit() -> void: # When a player hit an enemy
	if not wasHitten:
		wasHitten = true
		pv -= 1
		
		if hearths.size() > 0:
			var last_heart = hearths.pop_back()
			containter.remove_child(last_heart)
			last_heart.queue_free()
		
		_controlGameOver()
		
		await get_tree().create_timer(3).timeout
		wasHitten = false

func _controlGameOver() -> void:
	if pv <= 0:
		$HeadUpDisplay/FinalMessage.show()
		$HeadUpDisplay/FinalScore.text = "Your Score: " + str(score)
		$HeadUpDisplay/FinalScore.show()
		$HeadUpDisplay/Score.hide()
		
		$scoreTimer.stop()
		$enemyTimer.stop()
		
		wasHitten = true

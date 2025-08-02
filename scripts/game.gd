extends Node2D

@export var enemyScenes: Array[PackedScene]

@onready var containter = $HearthsLayer/HearthsContainer
@onready var enemyTimer = $enemyTimer
@onready var scoreTimer = $scoreTimer
@onready var background = $background
@onready var tileMap = $TileMapLayer

var score: int = 0
var pv = Global.maxPv

var isGameOver = false
var wasHit = false

var hearths: Array[TextureRect] = []
var hearthsTexture = preload("res://images/main/hearth.png")

var tileMapBackupData: Dictionary = {}
var backgroundBackupTexture: Texture2D

func _ready() -> void: # First execution
	for cell in tileMap.get_used_cells(): # save as Vector2: Vecror2 | Position as key
		var tileDate = tileMap.get_cell_atlas_coords(cell)
		var tileMapSourceId = tileMap.get_cell_source_id(cell)
		tileMapBackupData[cell] = [tileDate, tileMapSourceId]
	
	backgroundBackupTexture = background.texture

func _on_enemy_timer_timeout() -> void: # On end enemyTimer
	if not get_tree().get_nodes_in_group("enemies") or get_tree().get_nodes_in_group("enemies").size() < 5:
		var enemyScene = enemyScenes.pick_random()
		
		var enemyIstance = enemyScene.instantiate()
	
		enemyIstance.position = Vector2(576, 150)
		enemyIstance.player = $player
		
		if enemyIstance.name == "BlueGoblin":
			enemyIstance.position.y = 400
		
		enemyIstance.connect("enemyKilled", Callable(self, "_on_enemyKilled"))
		
		enemyIstance.add_to_group("enemies")
		add_child(enemyIstance)
		
func _on_enemyKilled(points):
	score += int(points)
	$HeadUpDisplay/Score.text = str(score)
	
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
		$HeadUpDisplay/GameOver.show()
		$HeadUpDisplay/RestartMessage.show()
		$HeadUpDisplay/FinalScore.text = "Your Score: " + str(score)
		$HeadUpDisplay/FinalScore.show()
		$HeadUpDisplay/Score.hide()
		
		$scoreTimer.stop()
		$enemyTimer.stop()
		
		$player.canMove = false
		$player.canCastMagic = false
		background.texture = preload("res://images/background/black.png")
		tileMap.clear()
		$player.position = Vector2(576, 500)
		
		for magic in get_tree().get_nodes_in_group("magics"):
			magic.queue_free()
		
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()
		
		wasHit = true
		
		await get_tree().create_timer(1).timeout
		isGameOver = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func start_game():
	score = 0
	pv = Global.maxPv
	isGameOver = false
	wasHit = false
	
	$enemyTimer.start()
	$scoreTimer.start()
	
	$HeadUpDisplay.visible = true
	$HearthsLayer.visible = true
	
	$HeadUpDisplay/GameOver.hide()
	$HeadUpDisplay/RestartMessage.hide()
	$HeadUpDisplay/FinalScore.hide()
	$HeadUpDisplay/Score.show()
	$HeadUpDisplay/Score.text = str(score)
	
	$player.canMove = true
	$player.canCastMagic = true
	$player.position = Vector2(576, 600)
	
	background.texture = backgroundBackupTexture
	
	for cell in tileMapBackupData: # Reload first tilemap
		tileMap.set_cell(cell, tileMapBackupData[cell][1], tileMapBackupData[cell][0])
	
	for i in range(Global.maxPv):
		var heart = TextureRect.new()
		heart.texture = hearthsTexture
		heart.custom_minimum_size = Vector2(32, 32)
		heart.expand = true
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearths.append(heart)
		containter.add_child(heart)

func _restart_game():
	start_game()

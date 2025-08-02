extends Node2D

@export var enemyScenes: Array[PackedScene]

@onready var containter = $HearthsLayer/HearthsContainer
@onready var scoreTimer = $scoreTimer
@onready var gameOverBackground = $GameOverBg
@onready var player = $player

var score: int = 0
var pv = Global.maxPv
var isGameOver = false
var wasHit = false

var hearths: Array[TextureRect] = []
var hearthsTexture = preload("res://images/main/hearth.png")

var currentRoom: Node2D = null
var isChangingRoom = false
var room_scenes := {
	"room1": preload("res://scenes/rooms/room1.tscn"),
	"room2": preload("res://scenes/rooms/room2.tscn"),
	"room3": preload("res://scenes/rooms/room3.tscn")
}

func _ready() -> void: # First execution
	Global.change_room.connect(_on_change_room)
	
func start_game():
	score = 0
	pv = Global.maxPv
	isGameOver = false
	wasHit = false
	gameOverBackground.visible = false
	
	$scoreTimer.start()
	
	$HeadUpDisplay.visible = true
	$HearthsLayer.visible = true
	
	$HeadUpDisplay/GameOver.hide()
	$HeadUpDisplay/RestartMessage.hide()
	$HeadUpDisplay/FinalScore.hide()
	$HeadUpDisplay/Score.show()
	$HeadUpDisplay/Score.text = str(score)
	
	player.canMove = true
	player.canCastMagic = true
	player.position = Vector2(576, 600)
	
	for heart in hearths:
		heart.queue_free()
	hearths.clear()
	
	for i in range(Global.maxPv):
		var heart = TextureRect.new()
		heart.texture = hearthsTexture
		heart.custom_minimum_size = Vector2(32, 32)
		heart.expand = true
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearths.append(heart)
		containter.add_child(heart)
		
	load_room("room1", "", "")

func _restart_game():
	start_game()

func load_room(room: String, door: String, direction_to_spawn: String) -> void:	
	# Clear previous room
	if currentRoom:
		currentRoom.queue_free()
		
	for magic in get_tree().get_nodes_in_group("magics"):
			magic.queue_free()
		
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.queue_free()
	
	# Load new room
	var scene: PackedScene = room_scenes.get(room)
	
	if not scene:
		push_error("ERROR_ROOM_NOT_FOUND")
		return
	
	currentRoom = scene.instantiate()
	add_child(currentRoom)
	
	# Spawn player
	var doorToSpown = currentRoom.get_node_or_null("Doors/" + door + "/Collision")
	if doorToSpown:
		var newPosition = doorToSpown.global_position
			
		if direction_to_spawn == "up":
			newPosition.y -= 40
		elif direction_to_spawn == "down":
			newPosition.y += 40
		elif direction_to_spawn == "left":
			newPosition.x -= 40
		elif direction_to_spawn == "right":
			newPosition.x += 40
		else:
			newPosition = Vector2(559, 560)
		
		player.position = newPosition
	else:
		player.position = Vector2(559, 560)
	
	# Enemy spawn
	var enemySpawns = currentRoom.get_node_or_null("EnemySpawns")
	if enemySpawns:
		for spawn in enemySpawns.get_children():
			var enemyScene = enemyScenes.pick_random()
			var enemy = enemyScene.instantiate()
			
			enemy.position = spawn.global_position
			enemy.player = player
			enemy.connect("enemyKilled", Callable(self, "_on_enemyKilled"))
			enemy.add_to_group("enemies")
			add_child(enemy)

func _on_change_room(target_room: String, target_door: String, direction_to_spawn: String):
	if isChangingRoom:
		return
	isChangingRoom = true
	load_room(target_room, target_door, direction_to_spawn)
	await get_tree().create_timer(0.5).timeout
	isChangingRoom = false

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
		$"../PauseMenu".hide()
		$scoreTimer.stop()
		
		player.canMove = false
		player.canCastMagic = false			
		player.position = Vector2(576, 500)
		
		for magic in get_tree().get_nodes_in_group("magics"):
			magic.queue_free()
		
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.queue_free()
		
		wasHit = true
		gameOverBackground.visible = true
		
		await get_tree().create_timer(1).timeout
		isGameOver = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

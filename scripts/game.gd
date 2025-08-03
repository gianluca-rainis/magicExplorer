extends Node2D

@export var enemyScenes: Array[PackedScene]
@export var bossScenes: Array[PackedScene]

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
	"room3": preload("res://scenes/rooms/room3.tscn"),
	"room4": preload("res://scenes/rooms/room4.tscn"),
	"room5": preload("res://scenes/rooms/room5.tscn"),
	"room6": preload("res://scenes/rooms/room6.tscn"),
	"room7": preload("res://scenes/rooms/room7.tscn"),
	"room8": preload("res://scenes/rooms/room8.tscn"),
	"room9": preload("res://scenes/rooms/room9.tscn"),
	"room10": preload("res://scenes/rooms/room10.tscn"),
	"room11": preload("res://scenes/rooms/room11.tscn"),
	"room12": preload("res://scenes/rooms/room12.tscn"),
	"room13": preload("res://scenes/rooms/room13.tscn"),
	"room14": preload("res://scenes/rooms/room14.tscn"),
	"room15": preload("res://scenes/rooms/room15.tscn"),
	"room16": preload("res://scenes/rooms/room16.tscn"),
	"room17": preload("res://scenes/rooms/room17.tscn"),
	"room18": preload("res://scenes/rooms/room18.tscn"),
	"room19": preload("res://scenes/rooms/room19.tscn"),
	"room20": preload("res://scenes/rooms/room20.tscn"),
	"room21": preload("res://scenes/rooms/room21.tscn"),
	"room22": preload("res://scenes/rooms/room22.tscn"),
	"room23": preload("res://scenes/rooms/room23.tscn"),
	"room24": preload("res://scenes/rooms/room24.tscn"),
	"room25": preload("res://scenes/rooms/room25.tscn"),
	"room26": preload("res://scenes/rooms/room26.tscn"),
	"room27": preload("res://scenes/rooms/room27.tscn"),
	"room28": preload("res://scenes/rooms/room28.tscn")
}

func _ready() -> void: # First execution
	Global.change_room.connect(_on_change_room)
	Global.changed_max_pv.connect(_on_max_pv_changed)
	
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
		var offset = 40
			
		if direction_to_spawn == "up":
			newPosition.y -= offset
		elif direction_to_spawn == "down":
			newPosition.y += offset
		elif direction_to_spawn == "left":
			newPosition.x -= offset
		elif direction_to_spawn == "right":
			newPosition.x += offset
		else:
			newPosition = Vector2(559, 560)
		
		player.position = newPosition
	else:
		player.position = Vector2(559, 560)
	
	# Enemy spawn
	var enemySpawns = currentRoom.get_node_or_null("EnemySpawns")
	if enemySpawns:
		for spawn in enemySpawns.get_children():
			if spawn.name == "Boss":
				if Global.defeated_bosses.get(room, false):
					continue
				
				var bossScene = bossScenes.pick_random()
				var boss = bossScene.instantiate()
				
				boss.position = spawn.global_position
				boss.player = player
				boss.roomName = room
				boss.connect("enemyKilled", Callable(self, "_on_boss_killed"))
				boss.add_to_group("enemies")
				add_child(boss)
			else:
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
	
func _on_max_pv_changed(new_value: int) -> void:
	pv = new_value
	
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

func _on_boss_killed(points: int, room: String):
	score += int(points)
	$HeadUpDisplay/Score.text = str(score)
	Global.defeated_bosses[room] = true	
	
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

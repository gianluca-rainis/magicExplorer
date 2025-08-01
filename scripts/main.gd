extends Node2D

@onready var pauseMenu = $PauseMenu
@onready var game = $game
@onready var resumeButton = $PauseMenu/ButtonsContainer/Resume
@onready var settingsButton = $PauseMenu/ButtonsContainer/Settings
@onready var quitButton = $PauseMenu/ButtonsContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pauseMenu.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_input(true)
	resumeButton.pressed.connect(_on_resume_pressed)
	settingsButton.pressed.connect(_on_settings_pressed)
	quitButton.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:	
	if game.isGameOver and event.is_pressed():
		game._restart_game()
	else:
		if event.is_action_pressed("ui_cancel"):
			if get_tree().paused:
				_resume_game()
			else:
				_pause_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pause_game():
	get_tree().paused = true
	pauseMenu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _resume_game():
	get_tree().paused = false
	pauseMenu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	_resume_game()

func _on_settings_pressed():
	pass

func _on_quit_pressed():
	get_tree().quit()

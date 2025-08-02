extends Node2D

@onready var titleScreen = $TitleScreen
@onready var pauseMenu = $PauseMenu
@onready var game = $game

@onready var music = $backgroundMusic

@onready var startButtonTitleScreen = $TitleScreen/ButtonsContainer/Start
@onready var settingsButtonTitleScreen = $TitleScreen/ButtonsContainer/Settings
@onready var quitButtonTitleScreen = $TitleScreen/ButtonsContainer/Quit

@onready var resumeButtonPauseMenu = $PauseMenu/ButtonsContainer/Resume
@onready var settingsButtonPauseMenu = $PauseMenu/ButtonsContainer/Settings
@onready var quitButtonPauseMenu = $PauseMenu/ButtonsContainer/Quit

@onready var pauseMenuInfoPanel = $PauseMenu/InfoPanel
@onready var titleScreenInfoPanel = $TitleScreen/InfoPanel
@onready var backupInfoPanelPauseMenuThemeOverrideStyle: StyleBox = pauseMenuInfoPanel.get_theme_stylebox("panel")
@onready var backupInfoPanelTitleScreenThemeOverrideStyle: StyleBox = titleScreenInfoPanel.get_theme_stylebox("panel")

@onready var titleScreenSettings = $TitleScreen/InfoPanel/Settings
@onready var pauseMenuSettings = $PauseMenu/InfoPanel/Settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	titleScreen.visible = true
	game.visible = false
	game.set_process(false)
	game.set_physics_process(false)
	game.set_process_unhandled_input(false)
	pauseMenu.visible = false
	titleScreenSettings.visible = false
	pauseMenuSettings.visible = false
	$PauseMenu/InfoPanel/InfoContainer.visible = true
	
	if not music.playing:
		music.play()
	
	music.stream.loop = true
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_unhandled_input(true)
	
	startButtonTitleScreen.pressed.connect(_on_start_pressed)
	settingsButtonTitleScreen.pressed.connect(_on_settings_pressed)
	quitButtonTitleScreen.pressed.connect(_on_quit_pressed)
	
	resumeButtonPauseMenu.pressed.connect(_on_resume_pressed)
	settingsButtonPauseMenu.pressed.connect(_on_settings_pressed)
	quitButtonPauseMenu.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:	
	if game.isGameOver and event.is_pressed():
		game._restart_game()
	else:
		if event.is_action_pressed("ui_cancel") and not titleScreen.visible:
			if get_tree().paused:
				_resume_game()
			else:
				_pause_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _toggle_InfoPanel_theme_stylebox(titleScreenStyleBox, pauseMenuStyleBox):
	titleScreenInfoPanel.remove_theme_stylebox_override("panel")
	pauseMenuInfoPanel.remove_theme_stylebox_override("panel")
	titleScreenInfoPanel.add_theme_stylebox_override("panel", titleScreenStyleBox)
	pauseMenuInfoPanel.add_theme_stylebox_override("panel", pauseMenuStyleBox)

func _pause_game():
	get_tree().paused = true
	pauseMenu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _resume_game():
	get_tree().paused = false
	pauseMenu.visible = false
	
	_toggle_InfoPanel_theme_stylebox(backupInfoPanelTitleScreenThemeOverrideStyle, backupInfoPanelPauseMenuThemeOverrideStyle)
	titleScreenSettings.visible = false
	pauseMenuSettings.visible = false
	$PauseMenu/InfoPanel/InfoContainer.visible = true
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _on_start_pressed():
	titleScreen.visible = false
	
	_toggle_InfoPanel_theme_stylebox(backupInfoPanelTitleScreenThemeOverrideStyle, backupInfoPanelPauseMenuThemeOverrideStyle)
	titleScreenSettings.visible = false
	pauseMenuSettings.visible = false
	$PauseMenu/InfoPanel/InfoContainer.visible = true
	
	game.visible = true
	game.set_process(true)
	game.set_physics_process(true)
	game.set_process_unhandled_input(true)
	game.start_game()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_resume_pressed():
	_resume_game()

func _on_settings_pressed():
	titleScreenSettings.visible = not titleScreenSettings.visible
	pauseMenuSettings.visible = not pauseMenuSettings.visible
	$PauseMenu/InfoPanel/InfoContainer.visible = not $PauseMenu/InfoPanel/InfoContainer.visible
	
	titleScreenSettings.setMusicPlayer(music)
	pauseMenuSettings.setMusicPlayer(music)
	
	if titleScreenSettings.visible or pauseMenuSettings.visible:
		var tempInfoTheme = StyleBoxTexture.new()
		var tempTitleTheme = StyleBoxTexture.new()
		tempInfoTheme.texture = preload("res://images/background/black.png")
		tempTitleTheme.texture = preload("res://images/background/black.png")
		_toggle_InfoPanel_theme_stylebox(tempInfoTheme, tempTitleTheme)
	else:
		_toggle_InfoPanel_theme_stylebox(backupInfoPanelTitleScreenThemeOverrideStyle, backupInfoPanelPauseMenuThemeOverrideStyle)

func _on_quit_pressed():
	get_tree().quit()

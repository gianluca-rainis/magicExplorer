extends Control

@onready var musicBus = AudioServer.get_bus_index("Master")
@onready var soundTrackSelector = $SettingsContainer/MusicContainer/SoundTracks
@onready var volumeSlider = $SettingsContainer/SoundLevelContainer/SoundLevel
@onready var fullscreenCheckbox = $SettingsContainer/WindowModeContainer/CheckFullscreen

var soundTracks: Array[AudioStream] = []
var soundTracksPaths: Array[String] = []
var musicPlayer: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	soundTracks = [
		preload("res://sounds/soundTrack_strings.ogg"),
		preload("res://sounds/soundTrack_piano.ogg"),
		preload("res://sounds/soundTrack_synth.ogg"),
		preload("res://sounds/soundTrack_woodwind.ogg")
	]
	
	soundTracksPaths = [
		"res://sounds/soundTrack_strings.ogg",
		"res://sounds/soundTrack_piano.ogg",
		"res://sounds/soundTrack_synth.ogg",
		"res://sounds/soundTrack_woodwind.ogg"
	]
	
	soundTrackSelector.clear()
	soundTrackSelector.add_item("MagicExplorer - Strings", 0)
	soundTrackSelector.add_item("MagicExplorer - Piano", 1)
	soundTrackSelector.add_item("MagicExplorer - Synth", 2)
	soundTrackSelector.add_item("MagicExplorer - Woodwind", 3)
	
	var styleboxChecked: Texture2D = preload("res://images/background/checkButtonOn.png")
	var styleboxUnChecked: Texture2D = preload("res://images/background/checkButtonOff.png")
	
	fullscreenCheckbox.add_theme_icon_override("checked", styleboxChecked)
	fullscreenCheckbox.add_theme_icon_override("unchecked", styleboxUnChecked)

	volumeSlider.min_value = -40
	volumeSlider.max_value = 60
	volumeSlider.value = AudioServer.get_bus_volume_db(musicBus)
	fullscreenCheckbox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	volumeSlider.value_changed.connect(_on_volume_changed)
	fullscreenCheckbox.toggled.connect(_on_fullscreen_toggled)
	soundTrackSelector.item_selected.connect(_on_soundTrack_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setMusicPlayer(player: AudioStreamPlayer):
	musicPlayer = player
	musicPlayer.stream.loop = true
	
	for music in soundTracks.size():
		if soundTracksPaths[music] == musicPlayer.stream.resource_path:	
			soundTrackSelector.select(music)
	
	volumeSlider.value = AudioServer.get_bus_volume_db(musicBus)

func _on_volume_changed(value):
	AudioServer.set_bus_volume_db(musicBus, value)

func _on_fullscreen_toggled(pressed):
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_soundTrack_selected(index):
	if index >= 0 and index < soundTrackSelector.item_count:
		if musicPlayer:
			if musicPlayer.playing:
				musicPlayer.stop()
			
			musicPlayer.stream = soundTracks[index]
			musicPlayer.stream.loop = true
			musicPlayer.play()

extends Area2D

@export var target_room: String
@export var target_door: String
@export var direction_to_spawn: String

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player":		
		Global.change_room.emit(target_room, target_door, direction_to_spawn)

extends Node

# Signals
signal change_room(target_room: String, target_door: String, direction_to_spawn: String)
signal changed_max_pv(new_Value: int)

# Main constants
const SPEED = 300.0
const numMagics = 1

# Enemy info
const blobPv = 1
const blobDamage = 1
const blobSpeed = 50.0
const blobScore = 200

const goblinPv = 1
const goblinDamage = 1
const goblinSpeed = 100.0
const goblinScore = 500

const goblinBluPv = 2
const goblinBluDamage = 2
const goblinBluSpeed = 150.0
const goblinBluScore = 1000

const dragonPv = 20
const dragonDamage = 5
const dragonSpeed = 50.0
const dragonScore = 70000

# Main variables (may change during the game)
var _maxPv = 5

var maxPv: int:
	get:
		return _maxPv
	set(value):
		if value != _maxPv:
			_maxPv = value
			emit_signal("changed_max_pv", _maxPv)

var collected_items: Dictionary = {}
var defeated_bosses: Dictionary = {}

# Magics variables (may change during the game)
var fireBoltSpeed = 400.0
var fireBoltDamage = 1.5
var fireBoltLifeTime = 1.0
var fireBoltKnockSpeed = 400

var airWallSpeed = 600.0
var airWallDamage = 1.0
var airWallLifeTime = 1.5
var airWallKnockSpeed = 700

var waterTrapSpeed = 0.0
var waterTrapDamage = 2.5
var waterTrapLifeTime = 3.0
var waterTrapKnockSpeed = 600

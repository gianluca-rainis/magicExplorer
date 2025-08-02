extends Node

# Main constants
const SPEED = 300.0
const numMagics = 1

# Enemy info
const goblinPv = 1
const goblinDamage = 1
const goblinSpeed = 100.0
const goblinScore = 500

const goblinBluPv = 2
const goblinBluDamage = 2
const goblinBluSpeed = 150.0
const goblinBluScore = 1000

# Main variables (may change during the game)
var maxPv = 3

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

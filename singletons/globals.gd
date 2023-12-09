extends Node
#stats
var coins := 0
var score := 0
var player_life = int(clamp(99,0,99))
var player_max_hp := 3.0
var player_hp = float(clamp(player_max_hp,0,player_max_hp))

#switchs, doors
var switch_is_on = false
var has_key = false
var is_alive = true


#powerups
var wall_jump_1 = false
var run = false
var max_air_jump = 0
var dash = true
var slow_fall = false

func _process(_delta):
	if coins == 100:
		player_life += 1
		coins = 0

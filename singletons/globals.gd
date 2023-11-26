extends Node
#stats
var coins := 0
var score := 0
var player_life = int(clamp(99,0,99))
var player_max_hp := 5
var player_hp = int(clamp(player_max_hp,0,player_max_hp))

#switchs, doors
var switch_is_on = false
var has_key = false


#powerups
var wall_jump_1 = false
var run = false
var max_air_jump = 1
var dash = false
var slow_fall = false

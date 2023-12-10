extends Node2D

@onready var player = $Nebuly
@onready var camera = $Camera

func _ready():
	
	player.follow_camera(camera)
#
	player.player_has_died.connect(reload_game)
	
	Globals.player_hp = Globals.player_max_hp
	
func reload_game():
	
	await get_tree().create_timer(1.0).timeout
	Globals.is_alive = true
	get_tree().reload_current_scene()

#func _physics_process(_delta):
	#if player.position.x < 250:
		#camera.enabled = false
		#static_camera.enabled = true
	#elif player.position.x >= 250:
		#camera.enabled = true
		#static_camera.enabled = false

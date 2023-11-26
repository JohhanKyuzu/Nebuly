extends Node2D

@onready var player = $Nebuly
@onready var camera = $Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	
	player.follow_camera(camera)
#
	player.player_has_died.connect(reload_game)
	Globals.player_hp = Globals.player_max_hp
	
func reload_game():
	
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

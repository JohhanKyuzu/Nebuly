extends Camera2D
@onready var nebuly = player

@export_category("Follow Character")
@export var player : CharacterBody2D

#@export_category("Camera Smoothing")
#@export var smoothing_enabled : bool
#@export_range(1,10) var smoothing_distance : int = 0

func _process(_delta):
	if Globals.is_alive:
		if nebuly.animation.flip_h == false:
			offset.x = lerp(offset.x,50.0,0.02)
		elif nebuly.animation.flip_h == true:
			offset.x = lerp(offset.x,-50.0,0.02)

#func _physics_process(delta):
	#if player != null:
		#var camera_position : Vector2
		#
		#if smoothing_enabled:
			#var weight : float = float(11 - smoothing_distance) / 100
			#camera_position = lerp(global_position, player.global_position, weight)
		#else:
			#camera_position = player.global_position
			#
		#global_position = camera_position.floor()

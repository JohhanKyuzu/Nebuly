extends Camera2D


@export_category("Follow Character")
@export var player : CharacterBody2D


func _physics_process(_delta):
	if position.x <= 300:
		offset.x = lerp(offset.x,0.0,0.02)
	if Globals.is_alive:
		if position.x > 300:
			if player.animation.flip_h == false:
				offset.x = lerp(offset.x,40.0,0.02)
			elif player.animation.flip_h == true:
				offset.x = lerp(offset.x,-40.0,0.02)

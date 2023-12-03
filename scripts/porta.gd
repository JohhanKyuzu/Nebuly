extends Area2D

#@export var destino := ([0,0])


#func transport(player):
#	player.position.x = destino[0]
#	player.position.y = destino[1]

@export var destino : String = ""
func transport(_player):
	get_tree().change_scene_to_file(destino)

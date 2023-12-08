extends CharacterBody2D
@onready var crate = $"."
@onready var sound_destroy = $SoundDestroy
@onready var area_collision = $DetectionArea/AreaCollision
@onready var collision = $Collision
@onready var tileset_mapa_1 = $TilesetMapa1




func dash_destroy():
	sound_destroy.play()
	await area_collision.call_deferred("queue_free")
	await collision.call_deferred("queue_free")
	tileset_mapa_1.scale = Vector2(0,0)
	await get_tree().create_timer(0.36).timeout
	queue_free()




func _on_detection_area_body_entered(body):
	if body.name == "Nebuly":
		call_deferred("dash_destroy")

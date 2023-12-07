extends CharacterBody2D
@onready var crate = $"."



func dash_destroy():
	queue_free()




func _on_detection_area_body_entered(body):
	if body.name == "Nebuly":
		dash_destroy()

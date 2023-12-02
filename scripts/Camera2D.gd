extends Camera2D
@onready var nebuly = $"../Nebuly"
@onready var camera = $"."

var current_position: Vector2

func _ready():
	current_position = position

func _process(_delta):
	if nebuly.animation.flip_h == false:
		offset.x = lerp(offset.x,50.0,0.02)
	elif nebuly.animation.flip_h == true:
		offset.x = lerp(offset.x,-50.0,0.02)

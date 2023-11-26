extends Camera2D
@onready var nebuly = $"../Nebuly"
@onready var camera = $"."

var current_position: Vector2

func _ready():
	current_position = position

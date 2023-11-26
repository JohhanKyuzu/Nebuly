extends Node2D

@export var WAIT_DURATION := 2.0

@onready var platform := $platform as AnimatableBody2D
@export var move_speed := 5.0
@export var distance := 192.0
@export var move_right := false
@export var move_left := false
@export var move_up := false
@export var move_down := false


var follow := Vector2.ZERO
var platform_center := 16.0

# Called when the node enters the scene tree for the first time.
func _ready():
	move_platform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	platform.position = platform.position.lerp(follow, 0.5)
	
	
func move_platform():
	if move_right:
		var move_direction = Vector2.RIGHT * distance
		var duration = move_direction.length() / float(move_speed * platform_center)
		var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
		platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)
	if move_left:
		var move_direction = Vector2.LEFT * distance
		var duration = move_direction.length() / float(move_speed * platform_center)
		var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
		platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)
	if move_up:
		var move_direction = Vector2.UP * distance
		var duration = move_direction.length() / float(move_speed * platform_center)
		var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
		platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)
	if move_down:
		var move_direction = Vector2.DOWN * distance
		var duration = move_direction.length() / float(move_speed * platform_center)
		var platform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		platform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_DURATION)
		platform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_DURATION)
		

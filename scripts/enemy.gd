extends CharacterBody2D

@onready var enemy = $texture as Sprite2D
@export var SPEED = 1600.0
const JUMP_VELOCITY = -400.0
@export var direction := -1
@export var score := 100

@onready var wall_detector := $WallDetector as RayCast2D
@onready var texture = $texture
@onready var anim = $anim


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if direction == -1:
		texture.flip_h = true
		wall_detector.target_position.x = -8
	if direction == 1:
		texture.flip_h = false
		wall_detector.target_position.x = 8
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.target_position *= -1
	
	velocity.x = direction * SPEED * delta
	move_and_slide()

func _on_anim_animation_started(anim_name):
	if anim_name == "hurt":
		$hurt.play()
		SPEED = 0
		velocity.y -= 80


func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		Globals.score += score
		queue_free()






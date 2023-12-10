extends CharacterBody2D

#region Speed

var max_speed : int = 300
const max_speed_padrao : int = 150
const max_speed_dash : int = 300
var acceleration : int = 15
var max_fall_speed : int = 550
var air_jumps_total : int = Globals.max_air_jump
var air_jumps_current : int = 0
#endregion

#region Jump

@export var jump_height : float = 30
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.25

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
#endregion

#region Dash

var dash_direction = Vector2(1,0)
var can_dash = false
var dashing = false
@onready var dash_timer = $DashTimer
#endregion

#region on ready vars

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var coyote_timer = $CoyoteTimer
@onready var jump_sound = $sounds/jump
@onready var hurt_sound = $sounds/hurt
@onready var nebuly = $"."
@onready var hurt_collision = $HurtBox/hurt_collision
@onready var spike_collision = $SpikeHurtBox/spike_collision
#endregion

#region vars
var direction
var jump_timer = 0
var wall_sliding = false
var can_wall_slide = true
var is_hurted := false
var knockback_vector := Vector2.ZERO
var is_jumping := false
var is_interacting := false
var interaction
var spike_hurt := false
#endregion

signal player_has_died()

func _process(_delta):
	if is_interacting:
		interaction_area()

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	direction = get_horizontal_velocity()
	velocity.y = clamp(velocity.y, -1000, max_fall_speed)
	
	
	if is_on_floor():
		air_jumps_current = air_jumps_total
		can_dash = true
		
	if !dashing:
		animation.rotation = 0
	
	if is_on_floor() and !dashing:
		max_speed = max_speed_padrao
		
	if is_on_floor() and direction == 0 and !dashing:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
	
	if !is_on_floor() and max_speed == max_speed_padrao and direction == 0 and !dashing:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		
		
	if is_on_wall():
		air_jumps_current = air_jumps_total
		max_speed = max_speed_padrao
		can_dash = true
			
	if Input.is_action_just_pressed("jump"):
		jump_timer = 0.4
	jump_timer -= delta
	
	if jump_timer > 0 and !is_jumping:
		jump_timer = 0.0
		if is_on_floor() or !coyote_timer.is_stopped():
			jump()
		
		if air_jumps_current > 0 and !is_on_floor() and !wall_sliding:
			air_jump()
		if wall_sliding:
			wall_jump()
	if is_jumping:
		if velocity.y > 0:
			is_jumping = false
	if !is_on_floor() and is_on_wall() and direction != 0 and Globals.wall_jump_1 and can_wall_slide:
		wall_sliding = true
		if velocity.y > 0:
			velocity.y /= 1.5
#			velocity.y = 0
	else:
		wall_sliding = false
		
	if direction > 0:
		velocity.x += acceleration
		animation.flip_h = false
		if !dashing:
			max_speed = max_speed_padrao
	elif direction < 0:
		velocity.x -= acceleration
		animation.flip_h = true
		if !dashing:
			max_speed = max_speed_padrao
			
	if Input.is_action_just_pressed("dash"):
		if dash_timer.is_stopped() and can_dash and Globals.dash:
			dash()
			
		
	if dashing:
		if velocity.y <= -1:
			if animation.flip_h == true:
				animation.rotation = 45.0
			elif animation.flip_h == false:
				animation.rotation = -45.0
		
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	if Input.is_action_just_released("jump"):
		if velocity.y < 0:
			velocity.y *= 0.5
			
		
	var was_on_floor = is_on_floor()
	
	
	_set_state()
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start() 

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func jump():
	is_jumping = true
	air_jumps_current = air_jumps_total
	velocity.y = jump_velocity
	jump_sound.play()

func wall_jump():
	if Globals.wall_jump_1 == true:
		var jump_vector = Vector2(500 * -direction, jump_velocity / 1.2)
		velocity = jump_vector
		jump_sound.play()
	
func air_jump():
	air_jumps_current -= 1
	velocity.y = jump_velocity
	jump_sound.play()

func dash():
	dash_timer.start()
	dashing = true
	hurt_collision.disabled = true
	spike_collision.disabled = true
	nebuly.set_collision_mask_value(3,false)
	max_speed = max_speed_dash
	acceleration = max_speed_dash
	max_fall_speed = 0
	if animation.flip_h == true:
		dash_direction = Vector2(-1,0)
	if animation.flip_h == false:
		dash_direction = Vector2(1,0)
	velocity = dash_direction.normalized() * max_speed_dash
	can_dash = false
	await get_tree().create_timer(.3).timeout
	max_fall_speed = 550
	acceleration = 15
	dashing = false
	hurt_collision.disabled = false
	spike_collision.disabled = false
	nebuly.set_collision_mask_value(3,true)

func get_horizontal_velocity() -> float:
	var horizontal := 0.0
	
	if Input.is_action_pressed("move_left"):
		horizontal -= 1.0
	if Input.is_action_pressed("move_right"):
		horizontal += 1.0
	return horizontal

func get_facing_direction():
	var flip
	if animation.flip_h == true:
		flip = -1
	else:
		flip = 1
	return flip

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration:=0.25, damage := 1.0):
	Globals.player_hp -= damage
	hurt_sound.play()
	
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1),duration)

	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false
	if Globals.player_hp <= 0:
		emit_signal("player_has_died")
		Globals.is_alive = false
		queue_free()
		Globals.player_life -= 1
	invencivel()

func spike_damage():
	if spike_hurt == false:
		spike_hurt = true
		if animation.flip_h == false:
			knockback_vector = (Vector2(-200,-200))
		else:
			knockback_vector = (Vector2(200,-200))
		
		take_damage(knockback_vector, 0.25, 0.5)

func invencivel(duration := 2.0):
	hurt_collision.disabled = true
	spike_collision.disabled = true
	animation.modulate = Color(1,1,1,0.5)
	await get_tree().create_timer(duration).timeout
	animation.modulate = Color(1,1,1,1)
	hurt_collision.disabled = false
	spike_collision.disabled = false
	
	spike_hurt = false

func interaction_area():
	if Input.is_action_just_pressed("move_up"):
		if interaction.has_method("transport"):
			interaction.transport(nebuly)

func _set_state():
	var state = "idle"
	if velocity.y < 0:
		state = "jump"
	elif !is_on_floor() and velocity.y > 0:
		state = "fall"
	elif direction != 0:
		state = "walk"
#		if Input.is_action_pressed("run"):
#			state = "run"
	elif direction == 0:
		if velocity.x > 10 or velocity.x < -10:
			state = "walk"
	if is_hurted:
		state = "hurt"
		
	if wall_sliding:
		state = "wall_grab"
	if dashing:
		state = "dash"
	
	if animation.name != state:
		animation.play(state)

func _on_hurt_box_body_entered(body):
	if body.is_in_group("enemies"):
		if Globals.player_life < 1:
			queue_free()
		else:
			if $rays/ray_right.is_colliding() or $rays/ray_right2.is_colliding():
				take_damage(Vector2(-200,-200))
			elif $rays/ray_left.is_colliding() or $rays/ray_left2.is_colliding():
				take_damage(Vector2(200,-200))

func _on_spike_hurt_box_body_shape_entered(_body_rid, _body, _body_shape_index, _local_shape_index):
	spike_damage()

func _on_interaction_detector_area_entered(area):
	is_interacting = true
	interaction = area

func _on_interaction_detector_area_exited(_area):
	is_interacting = false


func _on_interaction_detector_body_entered(_body):
	can_wall_slide = false
	print("false")

func _on_interaction_detector_body_exited(_body):
	can_wall_slide = true
	print("true")

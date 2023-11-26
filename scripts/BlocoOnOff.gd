extends StaticBody2D
@onready var anim = $anim
@onready var collision = $collision
@onready var sound = $sound

func _ready():
	Globals.switch_is_on = true


func _process(_delta):
	if Globals.switch_is_on:
		anim.play("ON")
		collision.disabled = false
	else:
		anim.play("OFF")
		collision.disabled = true
	if Input.is_action_just_pressed("liga desliga"):
		sound.play()
		if Globals.switch_is_on:
			Globals.switch_is_on = false
			Globals.switch_is_on = false
		elif !Globals.switch_is_on:
			Globals.switch_is_on = true
			Globals.switch_is_on = true

extends Area2D
@onready var som = $som


var coins := 1
func _on_body_entered(_body):
	
	$anim.play("collect")
	som.play()
	await $Collision.call_deferred("queue_free")
	Globals.coins += coins


func _on_anim_animation_finished():
		queue_free()

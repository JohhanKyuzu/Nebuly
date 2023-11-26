extends Area2D




func _on_body_entered(body):
	if body.name == "Nebuly":
		$"..".set_collision_layer_value(3,false)
		$".".set_collision_mask_value(1,false)
		body.velocity.y = -200
		owner.anim.play("hurt")

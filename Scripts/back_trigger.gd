extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		body.global_position = Vector2(2770, 616)
	else:
		queue_free()

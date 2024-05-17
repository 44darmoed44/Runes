extends CharacterBody2D

@export var rune: Node2D
@export var player: CharacterBody2D

var stay = false

func _physics_process(delta):
	if player.status == "amulet" and stay:
		player.velocity = velocity
	if not rune.move_block_bl:
		velocity.y += 50
		move_and_slide()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		stay = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		stay = false

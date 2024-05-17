extends CharacterBody2D

@export var speed = 350
@export var gravity = 50
var jump_force = 1000
var jump_bool = false

var direction = 1

func _ready():
	$AnimatedSprite2D.play("walk")
	
func _physics_process(delta):
	
	velocity.y += gravity
	velocity.x = direction * speed
	
	if jump_bool:
		velocity.y -= jump_force
		jump_bool = false
	
	if velocity.x < 0: $AnimatedSprite2D.flip_h = true
	else: $AnimatedSprite2D.flip_h = false
	
	move_and_slide()



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if body.status != "spider_stan":
			body.status = "spider_stan"
			body.camera_condiction = "normal"
			queue_free()
	direction = -direction
	$jump_collider/CollisionShape2D.rotate(PI)


func _on_jump_collider_body_entered(body):
	if body.name == "Player" and is_on_floor():
		velocity.y -= jump_force

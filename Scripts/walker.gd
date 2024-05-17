extends CharacterBody2D

var speed = 150
var gravity = 80

@export var trigger: Node2D
var trigger_speed = 25
var trigger_dir = 1

var condition = "idle"
var direction = -1

func _ready():
	trigger_move()
	await get_tree().create_timer(3).timeout
	await change_condition("walk")


func move():
	
	velocity.y += gravity
	
	if condition != "idle": velocity.x = speed * direction


func update_animation():
	$AnimatedSprite2D.play(condition)
	if velocity.x != 0:
		if velocity.x > 0: $AnimatedSprite2D.flip_h = false
		else: $AnimatedSprite2D.flip_h = true


func change_condition(cond: String):
	condition = cond
	match condition:
		"walk":
			speed = 150
		"run":
			speed = 400
	
	trigger.position = Vector2(0, trigger.position.y)
	trigger_dir = direction


func _physics_process(delta):
	move()
	update_animation()
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player" and condition == "run" and body.status != "spider_stan":
		body.status = "repel"
		body.repel_bl = true
		body.repel_on(direction)
	speed = 0
	velocity.x = 0
	direction = -direction
	condition = "idle"
	await  get_tree().create_timer(3).timeout
	await  change_condition("walk")


func trigger_move():
	if trigger.position.x >= 1050 or trigger.position.x <= -1050:
		trigger.position = Vector2(0, trigger.position.y)
	await get_tree().create_timer(0.01).timeout
	trigger.position = Vector2(trigger.position.x + (trigger_speed *  trigger_dir), trigger.position.y)
	await trigger_move()

func _on_trigger_area_body_entered(body):
	trigger.position = Vector2(0, trigger.position.y)
	if body.name == "Player" and body.status != "star_stan" and body.status != "spider_stan":
		change_condition("run")


func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "trigger_stop" and condition != "run":
		speed = 0
		velocity.x = 0
		direction = -direction
		condition = "idle"
		await  get_tree().create_timer(3).timeout
		await  change_condition("walk")

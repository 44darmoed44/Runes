extends CharacterBody2D

@export var speed = 300
@export var gravity = 50
@export var jump_force = -1200
var on_floor = true

@export var camera = Camera2D
var camera_counter = 1
var camera_condiction = "normal"
var camera_condition_counter = 2

@export var status = "free"
var repel_bl = false
var free_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("idle")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2:
			if on_floor and status != "spider_stan" and status != "star_stan":
				if camera_condiction == "normal" and camera_condition_counter == 2 and on_floor:
					camera_condiction = "mini"
					$AnimatedSprite2D.play("amulet_take_on")
					status = "amulet"
					camera_condition_counter =  1
				elif camera_condiction == "mini" and camera_condition_counter == 2:
					camera_condiction = "normal"
					var current_frame = $AnimatedSprite2D.get_frame()
					var current_progress = $AnimatedSprite2D.get_frame_progress()
					if $AnimatedSprite2D.animation == "amulet_take_on":
						$AnimatedSprite2D.play("amulet_take_off")
						$AnimatedSprite2D.set_frame_and_progress(9-current_frame, current_progress)
					else:
						$AnimatedSprite2D.play("amulet_take_off")
					status = "free"
					camera_condition_counter =  1
				else:
					camera_condition_counter +=  1


func _physics_process(delta):
	get_input()
	move_and_slide()
	update_animation()
	camera_zoom(camera_counter)
	on_floor = is_on_floor()


func camera_zoom(c_c):
	camera.zoom = Vector2(c_c, c_c)
	await get_tree().create_timer(0.01).timeout
	if c_c >= 0.6 and camera_condiction == "mini":
		camera_counter = c_c-0.020
		return await camera_zoom(c_c-0.020)
	if c_c <= 1 and camera_condiction == "normal":
		camera_counter = c_c+0.020
		return await camera_zoom(c_c+0.020)


func get_input():
	
	velocity.y += gravity
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if status == "free" and $AnimatedSprite2D.animation != "amulet_take_off":
		velocity.x = Input.get_axis("ui_left", "ui_right") * speed
		if Input.is_action_just_pressed("ui_select") and is_on_floor():
			velocity.y = jump_force
	elif status == "spider_stan" or status == "star_stan":
		if free_count >= 10:
			status = "free"
			free_count = 0
		else:
			velocity.x = 0
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				free_count += 1
	elif status == "amulet":
		velocity.x = 0

	if status == "star_stan" and is_on_floor() and repel_bl:
		velocity.y = -500


func update_animation():
	if status == "spider_stan":
		$AnimatedSprite2D.play("spider_stan")
	elif status == "amulet":
		if not $AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("amulet_idle")
	elif status == "star_stan":
		$AnimatedSprite2D.play("star_stan")
	else:
		if status == "free" and ($AnimatedSprite2D.animation != "amulet_take_off" or not $AnimatedSprite2D.is_playing()):
			if velocity.length() == 0:
				$AnimatedSprite2D.play("idle")
			else:
				if velocity.x != 0 and velocity.y == 0:
					$AnimatedSprite2D.play("walk")
				else:
					if velocity.y > 250:
						$AnimatedSprite2D.play("jump_down")
					elif velocity.y < 0:
						$AnimatedSprite2D.play("jump_up")
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = false
			elif velocity.x < 0:
				$AnimatedSprite2D.flip_h = true


func repel_on(dir):
	status = "star_stan"
	await get_tree().create_timer(0.01).timeout
	await repel(dir, 50, 10)
	repel_bl = false


func repel(dir, speed, repel_cnt):
	if repel_cnt > 0:
		global_position.x += speed * dir
		await get_tree().create_timer(0.01).timeout
		await repel(dir, speed-5, repel_cnt-1)


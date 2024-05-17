extends Node2D

@export var rune: String
var mouse_inside = false
var cnt = 0

@export var block: Node2D
@export var action: String
@export var dir: String
@export var distance: float
@export var move_cnt: int
@export var back_switch: bool
var rotate_cnt = 1

var move_block_bl = false
var mouse_cord = 0

var can_use = true

@export var player_status: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	match rune:
		"1Rune":
			$AnimationPlayer.play("1Rune")


func _physics_process(delta):
	check_press()
	if move_block_bl: mouse_cord = get_global_mouse_position()


func _on_area_2d_mouse_entered():
	mouse_inside = true


func _on_area_2d_mouse_exited():
	mouse_inside = false


func check_action():
	match action:
		"move":
			move(0, distance)
		"rotate":
			rot(0)
		"slide":
			slide()


func check_press():
	if mouse_inside \
		and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) \
			and can_use and player_status.status == "amulet":
		if cnt == 0:
			check_action()
			cnt += 1
	else:
		cnt = 0
		move_block_bl = false


func move(distance_cnt, dist):
	if distance_cnt != dist:
		can_use = false
		await  get_tree().create_timer(0.01).timeout
		match dir:
			"vertical":
				global_position = Vector2(global_position.x, global_position.y-move_cnt)
				return await move(distance_cnt+move_cnt, dist)
			"horizontal":
				global_position = Vector2(global_position.x+move_cnt, global_position.y)
				return await move(distance_cnt+move_cnt, dist)
	else:
		can_use = true
		distance = -distance
		move_cnt = -move_cnt


func rot(rot_cnt):
	if rot_cnt != move_cnt:
		can_use = false
		await get_tree().create_timer(0.01).timeout
		var rt = PI/(distance*move_cnt)
		match dir:
			"forward":
				block.rotate(rt)
			"back":
				block.rotate(-rt)
		return await rot(rot_cnt+rotate_cnt)
	else:
		if back_switch:
			move_cnt = -move_cnt
			rotate_cnt = -rotate_cnt
		can_use = true


func slide():
	move_block_bl = true
	move_block() 
	

func move_block():
	if move_block_bl:
		await  get_tree().create_timer(0.01).timeout
		
		position = mouse_cord
		
		await move_block()

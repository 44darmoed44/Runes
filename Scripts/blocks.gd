extends CharacterBody2D

@export var mod: String

func _ready():
	match mod:
		"line":
			$AnimationPlayer.play("line")
		"block":
			$AnimationPlayer.play("block")
		"elevator":
			$AnimationPlayer.play("elevator")
		_: 
			$AnimationPlayer.play("line")

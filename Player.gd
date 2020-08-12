extends KinematicBody2D

export var movement_speed = 100
export var jumping_enabled = false

var gravity = 0
var direction = Vector2.ZERO
var jump_strength = 50


func _ready():
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_A:
					direction.x = -1
				KEY_D:
					direction.x = 1
				KEY_SPACE:
					if is_on_floor() and jumping_enabled:
						gravity = -9.81 * jump_strength
		else:
			if [KEY_A, KEY_D].has(event.scancode):
				direction = Vector2.ZERO
	
func _physics_process(delta):
	gravity += 9.81 * 100 * delta
	
	move_and_slide(Vector2(direction.x * movement_speed, gravity), Vector2(0, -1))
	if is_on_floor():
		gravity = 0


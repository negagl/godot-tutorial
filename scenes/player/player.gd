extends Area2D

signal hit

@export var speed = 300

var screen_size
var input_velocity := Vector2.ZERO

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
	if !is_touch_device():
		# Detect key and add to the velocity
		if Input.is_action_pressed("move_right"):
			input_velocity.x += 1
		elif Input.is_action_pressed("move_left"):
			input_velocity.x -= 1
		else:
			input_velocity.x = 0
			
		if Input.is_action_pressed("move_up"):
			input_velocity.y -= 1
		elif Input.is_action_pressed("move_down"):
			input_velocity.y += 1
		else:
			input_velocity.y = 0
	
	velocity = input_velocity.normalized() * speed
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# Move
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Control animations
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_hud_move_player(move: Vector2) -> void:
	if is_touch_device():
		input_velocity = move
	


func is_touch_device() -> bool:
	return DisplayServer.is_touchscreen_available()

extends CanvasLayer

signal start_game
signal move_player

func _ready() -> void:
	$VirtualJoystick.hide()


func show_message(text) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over() -> void:
	if is_touch_device():
		$VirtualJoystick.hide()
		
	show_message("Perdiste")
	
	await $MessageTimer.timeout
	
	$Message.text = "Evita a los monstruos!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	
	$StartButton.show()


func update_score(score) -> void:
	$ScoreLabel.text = str(score)


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	
	if is_touch_device():
		$VirtualJoystick.show()
	
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func is_touch_device() -> bool:
	return DisplayServer.is_touchscreen_available()


func _on_virtual_joystick_analogic_change(move: Vector2) -> void:
	move_player.emit(move)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			# Mostrar el joystick donde se tocó
			$VirtualJoystick.position = event.position
			$VirtualJoystick.visible = true
		else:
			# Ocultar el joystick al soltar
			$VirtualJoystick.visible = false

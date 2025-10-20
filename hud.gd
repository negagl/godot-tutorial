extends CanvasLayer

signal start_game

func show_message(text) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Perdiste")
	
	await $MessageTimer.timeout
	
	$Message.text = "Evita a los monstruos!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score) -> void:
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()

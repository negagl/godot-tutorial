extends Node2D

@export var mob_scene: PackedScene

var score
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	adapt_mob_path_to_screen()


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Listos")
	get_tree().call_group("mobs", "queue_free")
	$Music.play()


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func adapt_mob_path_to_screen():
	var curve = $MobPath.curve
	curve.clear_points()

	var margin = 10.0 # opcional: para que los mobs aparezcan justo fuera del borde

	var top_left = Vector2(-margin, -margin)
	var top_right = Vector2(screen_size.x + margin, -margin)
	var bottom_right = Vector2(screen_size.x + margin, screen_size.y + margin)
	var bottom_left = Vector2(-margin, screen_size.y + margin)

	# Añadir puntos en sentido horario
	curve.add_point(top_left)
	curve.add_point(top_right)
	curve.add_point(bottom_right)
	curve.add_point(bottom_left)
	curve.add_point(top_left) # cerrar el loop

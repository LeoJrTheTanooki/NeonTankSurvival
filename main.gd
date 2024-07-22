extends Node

@export var mob_scene: PackedScene
var score
@onready var joystick : MultidirectionnalJoystick = $HUD/MultidirectionnalJoystick
@onready var sprite_2d = $Player



var dir : Vector2
var speed := 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect_signals()
	$TitleScreenMusic.play()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.movement == true:
		$Player.translate(dir*$Player.speed*delta)
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Player.movement = false
	$GameMusic.stop()
	await get_tree().create_timer(3.0).timeout
	$TitleScreenMusic.play()

	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$Player/TankSprite.animation = "3hp"
	$Player.movement = true
	$Player.health = 3
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$TitleScreenMusic.stop()
	$GameMusic.play()
	get_tree().call_group("mobs", "queue_free")
	


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction
	var velocity = Vector2(randf_range(70.0, 170.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)
	
func _on_hud_pause_game():
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		$HUD/PauseButton.texture_normal = ResourceLoader.load("res://assets/sprites/playIcon.png")
		$HUD/PauseOverlay/PauseMessage.show()
		$HUD/PauseOverlay.show()
		#$GameMusic.volume_db = -20
	else:
		$HUD/PauseButton.texture_normal = ResourceLoader.load("res://assets/sprites/pauseIcon.png")
		$HUD/PauseOverlay.hide()
		#$GameMusic.volume_db = 0
		
#Joystick Signals
func connect_signals ():
	var load_txt := func(indx: int,op_button: TS): 
		var meta_k : String = op_button.get_item_text(indx)
		var metadata : String = op_button.get_meta(meta_k,"")
		var k := metadata.begins_with("b")
		if metadata.is_empty(): return
		joystick.set("bigger_texture" if op_button.bigger else "small_texture",load(metadata))
	joystick.joystick_change.connect(change_direction)

func change_direction (dir_joystick: Vector2):
	dir = dir_joystick
	if dir != Vector2.ZERO && $Player.movement == true:
		$Player.rotation = dir.angle() + PI / 2


func _on_game_music_finished():
	$GameMusic.play()
	pass # Replace with function body.

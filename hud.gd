extends CanvasLayer

signal start_game
signal pause_game
var credits_show

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	$PauseButton.hide()
	$MultidirectionnalJoystick.hide()
	show_message("Game Over!")
	await $MessageTimer.timeout
	$Logo.show()
	$Message.hide()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$CreditsButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	$StartButton.hide()
	$Logo.hide()
	$CreditsButton.hide()
	$PauseButton.show()
	start_game.emit()


func _on_message_timer_timeout():
	$Message.hide()


func _on_pause_button_pressed():
	pause_game.emit()

func _input(event):
	if event is InputEventScreenTouch && event.is_pressed():
		$MultidirectionnalJoystick.show()
	elif event is InputEventJoypadButton || event is InputEventKey:
		$MultidirectionnalJoystick.hide()


func _on_credits_button_pressed():
	if credits_show:
		credits_show = false
		$PauseOverlay.show()
		$PauseOverlay/PauseMessage.hide()
		$PauseOverlay/CreditsMessage.show()
		$StartButton.hide()
		$CreditsButton.text = "Close"
	else:
		credits_show = true
		$PauseOverlay.hide()
		$PauseOverlay/CreditsMessage.hide()
		$StartButton.show()
		$CreditsButton.text = "Credits"
	pass # Replace with function body.

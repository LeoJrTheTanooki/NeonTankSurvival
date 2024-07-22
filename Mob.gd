extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$BulletSprite.animation = "default"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func player_hit():
	$BulletSprite.play("hit")
	linear_velocity = Vector2(0.0, 0.0)
	await $BulletSprite.animation_finished
	hide()

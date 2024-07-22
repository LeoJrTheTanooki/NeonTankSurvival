extends Area2D

signal health_depleted

@export var speed = 70
var screen_size
var angular_speed = PI
var health = 3
var max_health = 3
var movement = false
var direction = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#Movement
	direction = 0
	if movement == true:
		var velocity  = Vector2.ZERO
		if Input.is_action_pressed("ui_up"):
			velocity = Vector2.UP.rotated(rotation) * speed
		if Input.is_action_pressed("ui_down"):
			velocity = Vector2.DOWN.rotated(rotation) * speed
		if Input.is_action_pressed("ui_left"):
			direction = -1
		if Input.is_action_pressed("ui_right"):
			direction = 1
		rotation += angular_speed * direction * delta
			
		if velocity.length() > 0:
			$TankSprite.play()
		else:
			$TankSprite.stop()
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
		
#Invincibility frames
	if $InvincibilityTimer.time_left > 0 && health > 0:
		visible = not visible
	else: 
		visible = true
	

func start(pos):
	position = pos
	rotation = 0
	show()
	$CollisionShape2D.disabled = false
	health = 3
	$ExplosionSprite.hide()
	#$TankSprite.animation = "3hp"

func _on_body_entered(body):
	#Find a way to check is player_hit() even exists in the script
	print(body.name)
	#Prints either BodyNode2D or Mob
	body.player_hit()
	if $InvincibilityTimer.time_left == 0:
		health -= 1
		$InvincibilityTimer.start()
		if health >= max_health / 1.5:
			$TankSprite.animation = "2hp"
			$HitSfx.play()
		elif health > 0:
			$TankSprite.animation = "1hp"
			$HitSfx.play()
		else:
			$TankSprite.animation = "0hp"
			$FinalHitSfx.play()
			$ExplosionSprite.show()
			$ExplosionSprite.play("red")
			$ExplosionSprite.rotation = rotation * -1
			health_depleted.emit()
			$CollisionShape2D.set_deferred("disabled", true)

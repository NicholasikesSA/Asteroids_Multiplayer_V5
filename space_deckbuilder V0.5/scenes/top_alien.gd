class_name Enemy extends Area2D

signal enemy_destroyed(points, player)
@onready var screensize = get_viewport_rect().size
var momement_vector = Vector2(2,0)
var speed = 0
@onready var sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
var points = 500

func _ready():
	if Global.number_of_to_aliens == 1:
		$AlienTop1.play()
	var difficulty = Global.difficulty
	speed = randf_range(200*difficulty,300*difficulty)

func _physics_process(delta):
	global_position += momement_vector.rotated(rotation) * speed * delta
	var radius = collision_shape.shape.radius
	if (global_position.y + radius) < 0:
		global_position.y = (screensize.y + radius)
	elif (global_position.y - radius) > screensize.y:
		global_position.y = -radius
	elif (global_position.x + radius)< 0:
		global_position.x = (screensize.x + radius)
	elif (global_position.x - radius)> screensize.x:
		global_position.x = -radius
func destroy(player):
	emit_signal("enemy_destroyed", points, player)
	Global.number_of_to_aliens += -1
	queue_free()
	
func _on_body_entered(body):
	if body.name == "Player1":
		var player1 = body
		player1.die()
	if body.name == "Player2":
		var player2 = body
		player2.die()

func _on_alien_top_1_finished():
	$AlienTop2.play()


func _on_alien_top_2_finished():
	$AlienTop1.play()

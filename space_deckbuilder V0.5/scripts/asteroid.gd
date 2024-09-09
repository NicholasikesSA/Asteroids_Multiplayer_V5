class_name Asteroid extends Area2D

signal destroyed(pos, size, points, player)

@onready var screensize = get_viewport_rect().size
var momement_vector = Vector2(0,2)
var speed = 0
var initial_rotation
enum asteroidsize{LARGE, MEDIUM, SMALL}
@export var size = asteroidsize.LARGE

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
var rng = RandomNumberGenerator.new()
var asteriod_orientation = rng.randf_range(-15.0, 15.0)

var points: int:
	get:
		match size:
			asteroidsize.LARGE:
				return 100
			asteroidsize.MEDIUM:
				return 50
			asteroidsize.SMALL:
				return 25
			_:
				return 0
func _ready():
	initial_rotation = momement_vector.rotated(rotation)
	rotation = randf_range(0, TAU)
	var difficulty = Global.difficulty
	match size:
		asteroidsize.LARGE:
			speed = randf_range(30*difficulty,80*difficulty)
			sprite.texture = preload("res://resources/meteorBrown_big1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_big_collision.tres"))
		asteroidsize.MEDIUM:
			speed = randf_range(50*difficulty,100*difficulty)
			sprite.texture = preload("res://resources/meteorBrown_med1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_med_collision.tres"))
		asteroidsize.SMALL:
			speed = randf_range(70*difficulty,120*difficulty)
			sprite.texture = preload("res://resources/meteorBrown_small1.png")
			collision_shape.set_deferred("shape", preload("res://resources/asteroid_small_collision.tres"))
			
func _physics_process(delta):
	global_position += momement_vector.rotated(rotation) * speed * delta
	rotate(deg_to_rad(asteriod_orientation*delta))
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
	emit_signal("destroyed", global_position.x, global_position.y, size, points, player)
	queue_free()


func _on_body_entered(body):
	if body.name == "Player1":
		var player1 = body
		player1.die()
	if body.name == "Player2":
		var player2 = body
		player2.die()

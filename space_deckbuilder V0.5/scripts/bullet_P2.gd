extends Area2D

@export var speed = 350
@export var player_index = 2
@onready var animation = $Bullet_Skin
var movement_vector = Vector2(0,-1)
func start(pos):
	position = pos
	animation.play("Laser_travel_P2")
	
	
func _physics_process(delta):
	global_position += movement_vector.rotated(rotation) * speed * delta
	animation.play("Laser_travel_P2")
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Asteroid:
		var asteroid = area
		asteroid.destroy(player_index)
		queue_free()
	if area is Enemy:
		var enemy = area
		enemy.destroy(player_index)
		queue_free()

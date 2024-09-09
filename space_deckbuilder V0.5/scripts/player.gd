class_name Player extends CharacterBody2D

signal bullet_shot(bullet)
signal shield_start(time_invincible_on_shield, shield_cooldown, player_index)
signal shield_on_cooldown
signal died
@export var player_index = 1
@export var bullet_cooldown = 0.25
@export var time_invincible_on_respawn = 4
@export var time_invincible_on_shield = 3
@export var bullet_scene_1 = preload("res://scenes/bullet_P1.tscn")
@export var bullet_scene_2 = preload("res://scenes/bullet_P2.tscn")
@export var bullet_scene_3 = preload("res://scenes/bullet_P3.tscn")
@export var bullet_scene_4 = preload("res://scenes/bullet_P4.tscn")
@export var max_speed = 250
@export var turning = 100
@export var shield_cooldown = 5
@onready var screensize = get_viewport_rect().size
@onready var muzzle = $Muzzle
@onready var sprite = $Ship
@onready var shield = $Shield
@onready var collision = $CollisionShape2D
var can_shoot = true
var can_shield = true
var shield_in_cooldown = false
const acc = 75
const friction = 7
var alive = true
var number_awaiting = 0
var health = 3
var paused = false
func _ready():
	Global.shield_duration = time_invincible_on_shield
	Global.shield_cooldown = shield_cooldown
	shield.hide()
	number_awaiting = 0
	if player_index == 1:
		sprite.texture = preload("res://Player ship/Player_Ship_P1.png")
	if player_index == 2:
		sprite.texture = preload("res://Player ship/Player_Ship_P2.png")
	if player_index == 3:
		sprite.texture = preload("res://Player ship/Player_Ship_P3.png")
	if player_index == 4:
		sprite.texture = preload("res://Player ship/Player_Ship_P4.png")

func shoot():
	if Input.is_action_pressed("shoot_"+str(player_index)):
		if can_shoot:
			shoot_bullet(player_index)
			can_shoot = false
			await get_tree().create_timer(bullet_cooldown).timeout
			can_shoot = true
func _physics_process(delta):
	shoot()
	#to map multiple device inputs for local multiplayer: https://www.youtube.com/watch?v=zZ9hInuYOBU
	var input_vector = Vector2.ZERO 
	input_vector.y = Input.get_action_strength("down_"+str(player_index))-Input.get_action_strength("up_"+str(player_index))
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector.rotated(rotation) * max_speed, acc * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if Input.is_action_pressed("right_"+str(player_index)):
		rotate(deg_to_rad(turning*delta))
	if Input.is_action_pressed("left_"+str(player_index)):
		rotate(deg_to_rad(-turning*delta))
	move_and_slide()
	if Input.is_action_just_pressed("shield_" + str(player_index)) and can_shield:
		can_shield = false
		i_frames(true)
		shield.show()
		emit_signal("shield_start", time_invincible_on_shield, shield_cooldown)
		$/root/GlobalNodes/ShieldP1.start(time_invincible_on_shield)
		await $/root/GlobalNodes/ShieldP1.timeout
		i_frames(false)
		shield.hide()
		emit_signal("shield_on_cooldown")
		$/root/GlobalNodes/ShieldP1.start(shield_cooldown)
		await $/root/GlobalNodes/ShieldP1.timeout
		can_shield = true
	if global_position.y < 0:
		global_position.y = screensize.y
	elif global_position.y > screensize.y:
		global_position.y = 0
	elif global_position.x < 0:
		global_position.x = screensize.x
	elif global_position.x > screensize.x:
		global_position.x = 0
	$AnimatedSprite2D.animation = "thrust"
	if input_vector.y < 0:
		$AnimatedSprite2D.show()
	else:
		$AnimatedSprite2D.hide()

func shoot_bullet(player_who_did):
	var l1
	if player_index == 1:
		l1 = bullet_scene_1.instantiate()
	if player_index == 2:
		l1 = bullet_scene_2.instantiate()
	if player_index == 3:
		l1 = bullet_scene_3.instantiate()
	if player_index == 4:
		l1 = bullet_scene_4.instantiate()
	l1.global_position = muzzle.global_position
	l1.rotation = rotation
	emit_signal("bullet_shot", l1, player_who_did)
func i_frames(toggle):
	#print(toggle)
	if toggle == true:
		collision.disabled = true
		sprite.modulate.a8 = 100
		number_awaiting += 1
		#print("invincible")
	if toggle == false and number_awaiting == 1:
		sprite.modulate.a8 = 1000
		collision.disabled = false
		number_awaiting += -1
		#print("not invincible")
	if toggle == false and number_awaiting >= 1:
		number_awaiting += -1
	#print(number_awaiting)
func die():
	if alive == true:
		alive = false
		health -= 1
		emit_signal("died")
		sprite.visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
		$AnimatedSprite2D.hide()
func respawn(pos):
	if alive == false:
		alive = true
		i_frames(true)
		global_position = pos
		velocity = Vector2.ZERO
		sprite.visible = true
		process_mode = Node.PROCESS_MODE_INHERIT
		await get_tree().create_timer(time_invincible_on_respawn).timeout
		i_frames(false)

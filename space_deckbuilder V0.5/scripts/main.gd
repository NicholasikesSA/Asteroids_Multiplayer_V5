extends Node2D

var enemy1 = preload("res://scenes/alien_1.tscn")
var asteroid_scene = preload("res://scenes/asteroid.tscn")
@onready var screensize = get_viewport_rect().size
@onready var bullets1 = $bullet_from_who/bullets_p1
@onready var bullets2 = $bullet_from_who/bullets_p2
@onready var bullets3 = $bullet_from_who/bullets_p3
@onready var bullets4 = $bullet_from_who/bullets_p4
@onready var player1 = $Players/Player1
@onready var player2 = $Players/Player2
#@onready var player3 = $Players/Player3
#@onready var player4 = $Players/Player4
@onready var asteroids = $Asteroids
@onready var enemies = $Enemies
@onready var music = $Music/Track1
@onready var music_GameOver = $Music/GameOver1
@onready var hud =  $UI/HUD
@onready var timer = $UI/HUD/Game_Timer
@onready var game_over_screen = $UI/GameOverScreen
@onready var player_spawn_pos1 = $Player_Spawns/PlayerSpawnPos1
@onready var player_spawn_pos2 = $Player_Spawns/PlayerSpawnPos2
var running = true
var hold_on = false
var is_alien_on_screen = false
@export var asteroid_spawn_interval = 20
@export var difficulty_increase = .02
@export var num_of_asteroids_spawned = 5
@export var rounds_before_alien = 3
var p1_shield_bar = 0:
	set(value):
		p1_shield_bar = value
		hud.displaytimer = p1_shield_bar
var time = 0:
	set(value):
		time = value
		hud.displaytimer = time
var difficulty = 0.2:
	set(value):
		difficulty = value
		Global.difficulty = difficulty
var score1 = 0:
	set(value):
		score1 = value
		hud.score1 = score1
var score2 = 0:
	set(value):
		score2 = value
		hud.score2 = score2
var HP_P1:
	set(value):
		HP_P1 = player1.health
		hud.initial_lives_P1(HP_P1)
var HP_P2:
	set(value):
		HP_P2 = player2.health
		hud.initial_lives_P2(HP_P2)


func _ready():
	music.play()
	game_over_screen.visible = false
	hold_on = false
	score1 = 0
	score2 = 0
	
	HP_P1 = player1.health
	HP_P2 = player2.health
	player1.connect("bullet_shot", _on_player_bullet_shot)
	player2.connect("bullet_shot", _on_player_bullet_shot)
	#player3.connect("bullet_shot", _on_player_bullet_shot)
	#player4.connect("bullet_shot", _on_player_bullet_shot)
	player1.connect("died", _on_player_died)
	player2.connect("died", _on_player_died)
	#player3.connect("died", _on_player_died)
	#player4.connect("died", _on_player_died)
	if enemies.get_child_count() > 0:
		$Sound_Effects/EnemySpawn1.play()
	for enemy in enemies.get_children():
		enemy.connect("enemy_destroyed", _on_enemy_destroyed)
	for asteroid in asteroids.get_children():
		asteroid.connect("destroyed", _on_asteroid_destroyed)
func _on_player_bullet_shot(bullet, player_index):
	$Sound_Effects/LaserSound.play()
	if player_index == 1:
		bullets1.add_child(bullet)
	if player_index == 2:
		bullets2.add_child(bullet)
	if player_index == 3:
		bullets3.add_child(bullet)
	if player_index == 4:
		bullets4.add_child(bullet)
var loop_has_run = false
var accumulated_time = 0.0
var accumulated_time2 = 0.0

func _process(delta):
	time += delta
	accumulated_time += delta
	accumulated_time2 += delta
	natural_spawn(0,screensize.y/2)
func _on_enemy_destroyed(points, player_index):
	$Sound_Effects/AlienTopDeath.play()
	if player_index==1:
		score1 += points
	if player_index==2:
		score2 += points
	#if player_index==3:
		#score3 += points
	#if player_index==3:
		#score4 += points
func _on_asteroid_destroyed(posx, posy, size, points, player_index):
	if player_index==1:
		score1 += points
	if player_index==2:
		score2 += points
	#if player_index==3:
		#score3 += points
	#if player_index==3:
		#score4 += points
	$Sound_Effects/AsteroidDestroyed.play()
	for i in range(2):
		match size:
			Asteroid.asteroidsize.LARGE:
				spawn_asteroid(posx, posy, Asteroid.asteroidsize.MEDIUM)
			Asteroid.asteroidsize.MEDIUM:
				spawn_asteroid(posx, posy, Asteroid.asteroidsize.SMALL)
			Asteroid.asteroidsize.SMALL:
				pass
func natural_spawn(posx, posy):	
	if hold_on == false and accumulated_time >= asteroid_spawn_interval:
		if not loop_has_run:
			hold_on = true
			loop_has_run = true
			for i in range(num_of_asteroids_spawned):
				spawn_asteroid(posx, posy, Asteroid.asteroidsize.LARGE)
			difficulty += difficulty_increase
			num_of_asteroids_spawned += randi_range(-1, 2)
	if accumulated_time2 >= rounds_before_alien*asteroid_spawn_interval:
			$Sound_Effects/EnemySpawn1.play()
			spawn_enemy(posx, posy, "alien_1")
				
	if accumulated_time >= asteroid_spawn_interval:
		accumulated_time = 0.0
		hold_on = false
		loop_has_run = false
	if accumulated_time2 >= rounds_before_alien*asteroid_spawn_interval:
		accumulated_time2 = 0.0
	else:
		pass	
func spawn_enemy(posx, posy, type):
	var a
	if type == "alien_1":
		a = enemy1.instantiate()
		Global.number_of_to_aliens += 1
		a.global_position.y = 117
		a.global_position.x = -25
	a.connect("enemy_destroyed", _on_enemy_destroyed)
	enemies.call_deferred("add_child", a)
func spawn_asteroid(posx, posy, size):
	var a = asteroid_scene.instantiate()
	a.global_position.y = posy
	a.global_position.x = posx
	a.size = size
	a.connect("destroyed", _on_asteroid_destroyed)
	asteroids.call_deferred("add_child", a)
func _on_player_died():
	$Sound_Effects/PlayerDeath.play()
	if player1.health < 0 and player2.health < 0:
		await get_tree().create_timer(2).timeout
		music.stop()
		music_GameOver.play()
		if score1 > score2:
			print("1 won")
			Global.player_who_won = 1
			Global.final_score = score1
		if score2 > score2:
			Global.player_who_won = 2
			Global.final_score = score2
		if score1 == score2:
			Global.player_who_won = 12
			Global.final_score = score1
		game_over_screen.visible = true
	else:
		await get_tree().create_timer(1.7).timeout
		if player1.health >= 0 and player1.alive == false:
			player1.respawn(player_spawn_pos1.global_position)
			HP_P1 -= 1
		if player2.health >= 0 and player2.alive == false:
			player2.respawn(player_spawn_pos2.global_position)
			HP_P2 -= 1

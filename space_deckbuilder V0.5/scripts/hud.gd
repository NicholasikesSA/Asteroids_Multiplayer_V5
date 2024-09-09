extends Control

var timemin = 0
var timesec = 0
@onready var score1 = $Score1:
	set(value):
		score1.text = "SCORE = " + str (value)
@onready var score2 = $Score2:
	set(value):
		score2.text = str (value) + " = SCORE"
@onready var displaytimer = $Game_Timer:
	set(time):
		timemin = floor(time/59)
		timesec = time - 59*timemin
		if timemin >= 10 and timesec >= 10:
			displaytimer.text = "TIME: " + str(timemin) + ":" + str(round(timesec))
		if timemin < 9 and timesec >= 10:
			displaytimer.text = "TIME: 0" + str(timemin) + ":" + str(round(timesec))
		if timemin >= 10 and timesec < 9:
			displaytimer.text = "TIME: " + str(timemin) + ":" + "0" + str(round(timesec))
		if timemin < 9 and timesec < 9:
			displaytimer.text = "TIME: 0" + str(timemin) + ":" + "0" + str(round(timesec))
@onready var p1_shield_timer = $P1_Shield_Bar:
	set(value):
		p1_shield_timer.value = 5
var uilife_scene_P1 = preload("res://scenes/ui_life_P1.tscn")
var uilife_scene_P2 = preload("res://scenes/ui_life_P2.tscn")
@onready var lives_P1 = $Lives_P1
@onready var lives_P2 = $Lives_P2
var scene_path : String
var progress : Array
func _ready():
#	scene_path = "res://scenes/wip.tscn"
	P1_shield_bar.value = 100
func initial_lives_P1(amount):
	for ui in lives_P1.get_children():
		ui.queue_free()
	for i in amount:
		var ui = uilife_scene_P1.instantiate()
		lives_P1.add_child(ui)
func initial_lives_P2(amount):
	for ui2 in lives_P2.get_children():
		ui2.queue_free()
	for i in amount:
		var ui2 = uilife_scene_P2.instantiate()
		lives_P2.add_child(ui2)
#	ResourceLoader.load_threaded_request(scene_path)
#func _process(delta):
#	ResourceLoader.load_threaded_get_status(scene_path, progress)
	
#	P1_shield_bar.value = progress [0]
#	if P1_shield_bar.value >= 1.0:
#		get_tree().change_scene_to_packed(
#			ResourceLoader.load_threaded_get(scene_path		)
#		)

@onready var P1_shield_bar = $P1_Shield_Bar
var time_on1
var time_cool_off1
var on_cooldown = false

func _on_player_1_shield_start(time_invincible_on_shield, shield_cooldown):
	var tween = get_tree().create_tween()
	time_on1 = time_invincible_on_shield
	time_cool_off1 = shield_cooldown
	tween.tween_property(P1_shield_bar, "value", 0, time_invincible_on_shield).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(P1_shield_bar, "value", 100, shield_cooldown).set_trans(Tween.TRANS_LINEAR)

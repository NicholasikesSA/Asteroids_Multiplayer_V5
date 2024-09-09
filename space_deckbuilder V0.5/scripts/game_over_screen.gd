extends Control
@onready var whowon = $WhoWon

func _process(delta):
	who_won()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func who_won():
	if Global.player_who_won == 1:
		whowon.text = "PLAYER 1 VICTORY!!! 
		SCORE: " + str(Global.final_score)
	if Global.player_who_won == 2:
		whowon.text = "PLAYER 2 VICTORY!!! 
		SCORE: " + str(Global.final_score)
	if Global.player_who_won == 12:
		whowon.text = "TIE 
		SCORE: " + str(Global.final_score)

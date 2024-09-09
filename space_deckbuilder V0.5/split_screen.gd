extends Node


onready var players := {
	"1": {
		viewport = $"HBoxContainer/SubViewportContainer/SubViewport",
		camera = $"HBoxContainer/SubViewportContainer/SubViewport/Camera2D",
		player = $HBoxContainer/SubViewportContainer/SubViewport/Level/Player1,
	},
	"2": {
		viewport = $"HBoxContainer/SubViewportContainer2/SubViewport",
		camera = $"HBoxContainer/SubViewportContainer2/SubViewport/Camera2D",
		player = $HBoxContainer/SubViewportContainer/SubViewport/Level/Player2,
	}
}
func _ready() -> void:
	players["2"].viewport.world_2D

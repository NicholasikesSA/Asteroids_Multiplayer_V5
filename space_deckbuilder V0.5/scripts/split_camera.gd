extends Node


@onready var viewport1 = $HBoxContainer/SubViewportContainer1/SubViewport
@onready var viewport2 = $HBoxContainer/SubViewportContainer2/SubViewport
@onready var camera1 = $HBoxContainer/SubViewportContainer1/SubViewport/Camera2D
@onready var camera2 = $HBoxContainer/SubViewportContainer2/SubViewport/Camera2D
@onready var world = $HBoxContainer/SubViewportContainer1/World

func _ready():
	viewport2.world_2d = viewport1.world_2d
	camera1.target = world.get_node("Player1")
	camera2.target = world.get_node("Player2")

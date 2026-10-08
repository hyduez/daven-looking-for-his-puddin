extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_music()

func play_music() -> void:
	$Music.play()

func play_jump() -> void:
	$Jump.play()

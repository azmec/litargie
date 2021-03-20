extends Node2D

onready var player: = $Player

func _ready() -> void:
    player.connect("died", self, "_on_player_died")

func _on_player_died() -> void:
    get_tree().reload_current_scene()
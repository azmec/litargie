extends Node

onready var track: = $Track
	
func play_song(path: String) -> void:
	var song: = load(path)
	track.stream = song
	track.play() 

func stop_song() -> void:
	track.stop()
class_name EventParser
extends Node

func process_events(events: Dictionary) -> void:
	if events == {}: return

	for event in events:
		match event:
			"change_scene":
				SceneTransition.change_scene_to(events[event])

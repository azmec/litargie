class_name EventParser
extends Node

func process_events(events: Dictionary) -> void:
	if events == {}: return

	for event in events:
		match event:
			"change_scene":
				SceneTransition.start_scene_transition(get_node("/root/Game"),
														get_node("/root/Game").currentLevel,
														load(events[event]))

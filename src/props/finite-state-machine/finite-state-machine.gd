# Alright, here's how we're doing it.
# Each enemy will have it's base script, that of the KinematicBody2D,
# which will contain its values (speed, acceleration, etc.)
# All enemies will delegate their physics proceses to this script.
# This *should* give us some advantages:
# 1. We can add whatever state we'd like, to each individual enemy.
# 2. Each state is contained within itself.
# 3. Bla bla decoupling and simplicity let's just move on

extends Node

signal state_changed(state_name)

var states_map: Dictionary = {}
var current_state: String = "null"

onready var host: KinematicBody2D = get_parent()

func _ready():
	var states: = self.get_children()
	for state in states:				# populate our states dictionary 
		states_map[state.name] = state	# by name and node itself
	current_state = states[0].name		# set current state by string to the first one

func _physics_process(delta: float) -> void:
	states_map[current_state].update(host, delta)


tool
extends Node2D

export var height: int = -40

onready var columnTop: = $ColumnTop 
onready var columnMid: = $ColumnMid 
onready var columnBottom: = $ColumnBottom 

func _ready() -> void:
	pass

func _process(_delta: float) -> void: 
	if Engine.editor_hint: 
		columnTop.position.y = height

		columnMid.position.y = (height / 2) - 4

		var distance_between_ends: float = columnTop.position.distance_to(columnBottom.position)
		columnMid.region_rect.size.y = distance_between_ends

		property_list_changed_notify()
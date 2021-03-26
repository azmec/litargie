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

		columnMid.position.y = int(height / 2) 
		#columnMid.region_rect.h 

		property_list_changed_notify()
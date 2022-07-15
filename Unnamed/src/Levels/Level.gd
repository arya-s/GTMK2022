extends Node

const WORLD = preload("res://src/World/World.gd")

onready var bonfire = $Bonfire

func _ready():
	var parent = get_parent()
	
	if parent is WORLD:
		parent.current_level = self
		
	bonfire.set_active(State.bonfires[name].active)

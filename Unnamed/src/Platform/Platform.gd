extends StaticBody2D

signal free_spawner(spawner_id)

const dices = [
	preload("res://src/Platform/Dice1.tscn"),
	preload("res://src/Platform/Dice2.tscn"),
	preload("res://src/Platform/Dice3.tscn"),
	preload("res://src/Platform/Dice4.tscn"),
	preload("res://src/Platform/Dice5.tscn"),
	preload("res://src/Platform/Dice6.tscn")
]

const lengths = [
	3 * 16,
	3 * 16,
	2 * 16,
	2 * 16,
	1 * 16,
	1 * 16
]

class_name Platform

var sprite: Sprite
var collider: CollisionShape2D
var type: int
var overlap: Area2D
var spawner_id

func _init(type: int, spawner_id):
	self.type = type
	self.spawner_id = spawner_id
	add_to_group('jump_platforms')
	set_collision_layer_bit(0, true)
	set_collision_layer_bit(1, true)
	add_sprite(dices[type], lengths[type])
	add_collider(lengths[type])

func add_sprite(Dice, length):
	sprite = Dice.instance()
	sprite.region_rect = Rect2(0, 0, length, 16)
	add_child(sprite)
	
func add_collider(length: int):
	var extents = Vector2(length/2, 8)
	var shape = RectangleShape2D.new()
	shape.extents = extents
	
	collider = CollisionShape2D.new()
	collider.shape = shape
	collider.position = extents
	add_child(collider)

	overlap = Area2D.new()
	overlap.set_collision_layer_bit(0, true)
	overlap.set_collision_layer_bit(1, true)
	overlap.add_child(collider.duplicate())
	overlap.connect("body_entered", self, "_on_Area2D_body_entered")
	add_child(overlap)
	
static func get_lengths(type):
	return lengths[type]

func free_up():
	emit_signal("free_spawner", spawner_id)
	queue_free()

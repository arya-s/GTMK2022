extends Node

export(int) var level = 0

onready var initial_spawn_position = $InitialSpawnPosition
onready var roomshape_collider = $RoomShape/Collider

var player_stats = GameResourceLoader.player_stats

func _ready():
	setup_level_boundaries()
	setup_level_meta()

func setup_boundary_collider(name: String, position: Vector2, extents: Vector2) -> void:
	var shape = RectangleShape2D.new()
	shape.extents = extents
	
	var collider = CollisionShape2D.new()
	collider.shape = shape
	
	var body = StaticBody2D.new()
	body.name = name
	body.global_position = position
	body.set_collision_layer_bit(1, true)
	body.add_child(collider)
	body.add_to_group("level_boundaries")
	
	add_child(body)
	
func setup_level_boundaries() -> void:
	var room_size: Vector2 = roomshape_collider.shape.extents
	var boundary_thickness = 10
	
	# We don't need a boundary for the bottom because bottom = death
	setup_boundary_collider(
		"LevelBoundaryTop",
		Vector2(room_size.x, -boundary_thickness),
		Vector2(room_size.x, boundary_thickness))
	setup_boundary_collider(
		"LevelBoundaryRight",
		Vector2(room_size.x * 2 + boundary_thickness, room_size.y),
		Vector2(boundary_thickness, room_size.y))
	setup_boundary_collider(
		"LevelBoundaryLeft", 
		Vector2(-boundary_thickness, room_size.y), 
		Vector2(boundary_thickness, room_size.y))

func setup_level_meta() -> void:
	player_stats.current_level = level
	State.current_level = self.filename
	State.player_spawn_point = initial_spawn_position.global_position

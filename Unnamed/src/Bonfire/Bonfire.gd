extends Node2D

onready var particles_base = $ParticlesBase
onready var particles_core = $PartcilesCore
onready var spawn_point = $SpawnPoint
onready var lit_sound = $LitSound
onready var heal_area = $HealArea

export(bool) var ACTIVE = false
export(State.DIRECTION) var FACING = State.DIRECTION.LEFT

func set_active(active):
	ACTIVE = active
	particles_base.emitting = active
	particles_core.emitting = active


func _on_Bonfire_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("fire_ball"):
		
		if not ACTIVE:
			lit_sound.play()
		
		var level = get_node("../").name
		State.last_bonfire = level
	
		State.player_spawn_point = spawn_point.global_position
		State.bonfires[level].active = true
		State.bonfires[level].bonfire = self
		State.player_spawm_facing = FACING
		set_active(true)
		heal_area.ACTIVE = true

extends KinematicBody2D

class_name Burnable

onready var burnout_timer = $BurnoutTimer
onready var spread_area_collider = $SpreadArea/Collider
onready var propagation_timer = $PropagationTimer
onready var particles_base = $ParticlesBase
onready var particles_core = $PartcilesCore

export(bool) var is_burning = false

var neighbors = []
var vel = Vector2.ZERO

func _physics_process(delta):
	vel += Vector2(0, 400) * delta
	vel = move_and_slide(vel, Vector2.UP, true, 1, 0, false)

func burn():
	if not is_burning:
		is_burning = true
		burnout_timer.start()
		propagation_timer.start()
		particles_base.emitting = true
		particles_core.emitting = true

func _on_BurnTimer_timeout():
	queue_free()

func _on_SpreadArea_area_entered(area):
	neighbors.append(area.get_node("../"))

func _on_PropagationTimer_timeout():
	if is_burning:
		for neighbor in neighbors:
			# some neighbors might already hav burned out
			if is_instance_valid(neighbor):
				neighbor.burn()

func _on_Hurtbox_hit(damage, attacker):
	if not is_burning:
		burn()

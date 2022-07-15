extends Node

onready var player_dying_sound = $PlayerDyingSound
onready var rat_dying_sound = $RatDyingSound
onready var secret_reveal_sound = $SecretRevealSound
onready var boss_hit_sound_1 = $BossHitSound1
onready var boss_hit_sound_2 = $BossHitSound2
onready var boss_hit_sound_3 = $BossHitSound3
onready var boss_hit_sound_4 = $BossHitSound4
onready var player_hit_sound = $PlayerHitSound

func play_player_dying_sound():
	player_dying_sound.play()

func play_rat_dying_sound():
	rat_dying_sound.play()

func play_secret_reveal_sound():
	secret_reveal_sound.play()
	
func play_boss_hit_sound():
	var hit_sounds = [boss_hit_sound_1, boss_hit_sound_2, boss_hit_sound_3, boss_hit_sound_4]
	var hit_sound = hit_sounds[randi() % hit_sounds.size()]
	hit_sound.play()

func play_player_hit_sound():
	player_hit_sound.play()

func freeze_frame(time_scale, duration):
	Engine.time_scale = time_scale
	yield(get_tree().create_timer(duration * time_scale), "timeout")
	Engine.time_scale = 1.0

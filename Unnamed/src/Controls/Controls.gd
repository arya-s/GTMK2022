extends Node

enum RumbleStrength { Light, Medium, Strong }

# Length in seconds
enum RumbleLength { VeryShort, Short, Medium, Long }


func rumble_gamepad(strength, length):
	var weak_motor = 0
	var strong_motor = 0
	var rumble_length = 0
	
	match strength:
		RumbleStrength.Light:
			weak_motor = 0.15
			strong_motor = 0.15
		RumbleStrength.Medium:
			weak_motor = 0.45
			strong_motor = 0.45
		RumbleStrength.Strong:
			weak_motor = 0.8
			strong_motor = 0.8
	
	match length:
		RumbleLength.VeryShort:
			rumble_length = 0.15
		RumbleLength.Short:
			rumble_length = 0.5
		RumbleLength.Medium:
			rumble_length = 1
		RumbleLength.Long:
			rumble_length = 2
	
	
	Input.start_joy_vibration(0, weak_motor, strong_motor, rumble_length)

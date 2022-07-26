extends TileMap

func get_plat_type():
	if is_in_group('plat_1'):
		return 0
	if is_in_group('plat_2'):
		return 1
	if is_in_group('plat_3'):
		return 2
	return null

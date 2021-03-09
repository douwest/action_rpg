extends Area2D

func is_colliding() -> bool:
	return self.get_overlapping_areas().size() > 0

func get_push_vector() -> Vector2:
	var areas = self.get_overlapping_areas()
	var push_vector = Vector2.ZERO
	if is_colliding():
		var area = areas[0]
		push_vector = area.global_position.direction_to(self.global_position)
		push_vector = push_vector.normalized()
	return push_vector

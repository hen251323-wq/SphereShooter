extends Node3D

@export var template_body: RigidBody3D
@export_custom(PROPERTY_HINT_LINK, "suffix:m") var cube_offset: Vector3

func spawn_body(body_position: Vector3):
	var body_duplicate = template_body.duplicate()
	body_duplicate.position = body_position + Vector3(0.0001, 0.0001, 0.0001)
	body_duplicate.process_mode = Node.PROCESS_MODE_INHERIT
	
	add_child(body_duplicate)

func _ready() -> void:
	var wall_positions = [
		template_body.position + 6 * Vector3.LEFT,
		template_body.position + 9 * Vector3.LEFT
	]
	
	for i in range(2):
		for z in range(-2, 3):
			for y in range(0, 5 * i + 5):
				spawn_body(wall_positions[i] + cube_offset * Vector3(0, y, z))
	
	for z in range(-2, 3):
		for x in range(-4, 5):
			for y in range((-abs(z) + 4) + (-abs(x) + 4)):
				spawn_body(template_body.position + cube_offset * Vector3(x, y, z))
				
	remove_child(template_body)

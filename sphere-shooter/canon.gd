extends Node3D

@export var direction_director_node: Node3D;
@export var base_sphere: RigidBody3D
@export_custom(PROPERTY_HINT_LINK, "suffix:m/s") var sphere_velocity: Vector3
@export_custom(PROPERTY_HINT_LINK, "suffix:m/s") var minimal_sphere_velocity_length: float
@export_custom(PROPERTY_HINT_LINK, "suffix:m/s") var maximal_sphere_velocity_length: float
@export_custom(PROPERTY_HINT_LINK, "suffix:°/s")  var rotation_speed: float
@export_custom(PROPERTY_HINT_LINK, "suffix:m/s")  var velocity_increase: float

var direction_director_mesh_instance: MeshInstance3D

func update_director() -> void:
	var sphere_velocity_direction = sphere_velocity.normalized()
	var director_basis = direction_director_node.basis
	director_basis.y = sphere_velocity_direction
	director_basis.x = director_basis.z.cross(sphere_velocity_direction)
	
	direction_director_node.basis = director_basis
	direction_director_node.transform = direction_director_node.transform.orthonormalized()
	
	var director_distance = sphere_velocity.length() / minimal_sphere_velocity_length + 0.5
	direction_director_mesh_instance.position.y = director_distance

func rotate_sphere_velocity(delta: float):
	sphere_velocity = sphere_velocity.rotated(Vector3.BACK, delta * deg_to_rad(rotation_speed))
	
	update_director()
	
func increase_sphere_velocity(delta: float):
	var increase = delta * Vector3(velocity_increase, velocity_increase, velocity_increase)
	increase *= sphere_velocity
	
	var next_velocity_length = (sphere_velocity + increase).length()
	
	if (next_velocity_length < minimal_sphere_velocity_length or 
		next_velocity_length > maximal_sphere_velocity_length):
			return

	sphere_velocity += increase
	
	update_director()
	
func shoot_sphere():
	var sphere_duplicate = base_sphere.duplicate()
	sphere_duplicate.process_mode = Node.PROCESS_MODE_INHERIT
	sphere_duplicate.freeze = false
	
	sphere_duplicate.linear_velocity = sphere_velocity
	add_child(sphere_duplicate)

func _ready() -> void:
	direction_director_mesh_instance = direction_director_node.get_child(0)

	update_director()
	
func _unhandled_input(event: InputEvent) -> void:
	
	if (event is not InputEventKey):
		return
	
	if (event.is_action_pressed("sphere_shoot")):
		shoot_sphere()

func _process(delta: float) -> void:
	
	if (Input.is_action_pressed("sphere_velocity_rotate_up")):
		rotate_sphere_velocity(delta)
	
	if (Input.is_action_pressed("sphere_velocity_rotate_down")):
		rotate_sphere_velocity(-delta)
		
	if (Input.is_action_pressed("sphere_velocity_increase")):
		increase_sphere_velocity(delta)
		
	if (Input.is_action_pressed("sphere_velocity_decrease")):
		increase_sphere_velocity(-delta)
	
	pass

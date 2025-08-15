extends Node

func _ready():
	# Wait a frame to ensure everything is loaded
	await get_tree().process_frame
	print("=== Collision Setup Debug ===")
	# Find the labyrinth mesh and create collision from it
	var labyrinth_node = get_node("../labyrinth2")
	if labyrinth_node:
		print("Found labyrinth node: ", labyrinth_node.name)
		print("Labyrinth children: ", labyrinth_node.get_children())
		
		# Find the MeshInstance3D in the labyrinth
		var mesh_instance = find_mesh_instance(labyrinth_node)
		if mesh_instance:
			print("Found mesh instance: ", mesh_instance.name)
			if mesh_instance.mesh:
				print("Mesh type: ", mesh_instance.mesh.get_class())
				print("Mesh surface count: ", mesh_instance.mesh.get_surface_count())
				
				# Create collision shape from mesh
				var collision_shape = mesh_instance.mesh.create_trimesh_shape()
				if collision_shape:
					print("Created collision shape type: ", collision_shape.get_class())
					
					# Find the collision shape node and assign the shape
					var collision_node = get_node("../labyrinth2/StaticBody3D_Labyrinth/StaticBody3D_Labyrinth#CollisionShape3D_Labyrinth")
					if collision_node:
						collision_node.shape = collision_shape
						
						# Apply the mesh instance transform to the collision shape
						collision_node.transform = mesh_instance.transform
						
						print("Assigned collision shape to node")
						print("Collision node enabled: ", not collision_node.disabled)
						print("StaticBody3D name: ", collision_node.get_parent().name)
						print("Applied mesh transform: ", collision_node.transform)
						
						# Check if the shape has data
						if collision_shape is ConcavePolygonShape3D:
							var faces = collision_shape.get_faces()
							print("Collision shape has ", faces.size() / 3, " triangles")
					else:
						print("Could not find collision node")
						print("Available nodes under labyrinth2:")
						debug_print_tree(labyrinth_node, 0)
				else:
					print("Failed to create collision shape")
			else:
				print("Mesh instance has no mesh")
		else:
			print("Could not find mesh instance")
			print("Available nodes under labyrinth2:")
			debug_print_tree(labyrinth_node, 0)
	else:
		print("Could not find labyrinth node")

func debug_print_tree(node, depth):
	var indent = ""
	for i in depth:
		indent += "  "
	print(indent + node.name + " (" + node.get_class() + ")")
	for child in node.get_children():
		debug_print_tree(child, depth + 1)

func find_mesh_instance(node):
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_mesh_instance(child)
		if result:
			return result
	return null

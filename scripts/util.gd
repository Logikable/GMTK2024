extends Node

################################### Node operations ##########################################

func global_scale(node: Node) -> Vector2:
  var scale = 1.0
  while node and node.has_method('get_parent'):
    if node.has_method('get_scale'):
      scale *= node.get_scale()
    node = node.get_parent()
  return scale


func global_rect(node: Node) -> Rect2:
  var global_scale = global_scale(node)
  var global_rect = Rect2(node.global_position, node.size * global_scale)
  return global_rect


func delete_node(node: Node) -> void:
  # Godot's version of deleting a node.
  if not node:
    return
  if node.has_method('get_parent') and node.get_parent():
    node.get_parent().remove_child(node)
  node.queue_free()


################################### Grid operations ##########################################


# The first coord is row #, the second is column #.
func index_to_coords(idx : int, size : int) -> Vector2:
  return Vector2(idx / size, idx % size)
  
  
func coords_to_index(coords : Vector2, size : int) -> int:
  if (coords.x < 0 or coords.y < 0 or
      coords.x >= size or coords.y >= size):
    return -1
  var idx : float = coords.x * size + coords.y
  assert(int(idx) == idx)
  return int(idx)


# Sides must be adjacent, not corners.
func adjacent(c1 : Vector2, c2 : Vector2) -> bool:
  if c1 == c2:
    return false
  if c1.x == c2.x and abs(c1.y - c2.y) == 1:
    return true
  if c1.y == c2.y and abs(c1.x - c2.x) == 1:
    return true
  return false

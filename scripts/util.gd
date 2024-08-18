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
  
  
func parent_center(node: Node) -> Vector2:
  assert(node.has_method('get_parent') and node.has_method('get_parent_area_size'))
  return node.get_parent_area_size() * node.get_parent().scale / 2


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


const TOUCHING : Array[Vector2] = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
func touching() -> Array[Vector2]:
  return TOUCHING


func around_me(width : int) -> Array[Vector2]:
  assert(width % 2 == 1)
  var start_idx = -(width / 2)
  var ret : Array[Vector2] = []
  for i in width:
    for j in width:
      ret.append(Vector2(start_idx + i, start_idx + j))
  assert(len(ret) == width ** 2)
  return ret
  

################################### Math operations ##########################################

func sum(array : Array[float]) -> float:
  return array.reduce(func(x, y): return x + y, 0.0)

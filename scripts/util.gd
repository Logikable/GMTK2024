extends Node

################################### Global Constants ##########################################

var COLOURS: Dictionary = {
  -1: Color(0, 0, 0, 0),    # Clicky cubie; has a custom asset. See below.
  0: Color(0, 0, 0, 0),     # Means an empty tile.
  1: Color.html('69FF66'),  # Green.
  2: Color.html('66DAFF'),  # Blue.
  3: Color.html('D766FF'),  # Purple.
  4: Color.html('FFB966'),  # Yellow.
}
const CUBIE_TOOLTIPS: Dictionary = {
  -1: "",
  0: "",
  1: "Generates 1 cubie/s\n\nDrag to move",
  2: "Doubles output of adjacent cubies\n\nDrag to move",
  3: "Increases cube output in a 3x3 area by 10%\n\nDrag to move",
  4: "Every 10 minutes, supercharges ALL cubes, doubling output\n\nDrag to move",
}
const NAME: Dictionary = {
  0: 'Unknown',
  1: 'Cubie',
  2: 'Wowie',
  3: 'Aurie',
  4: 'Chargie',
}
const CUBIE_TEXTURE: Dictionary = {
  -1: 'res://assets/O5ILzWu.png',
  0: 'Unknown',
  1: "res://assets/5Ijg6wc.png",
  2: "res://assets/AGiIs44.png",
  3: "res://assets/A4hYt9F.png",
  4: "res://assets/2jAEXOC.png",
}
const CUBIE_SHOP_ICON: Dictionary = {
  1: "res://assets/AJ98hLR.png",
  2: "res://assets/g05M7EO.png",
  3: "res://assets/5KPdnyj.png",
  4: "res://assets/OxVEsDw.png",
}

const GRID_PIXELS = {
  1: 120,   # 120 pixel ea
  2: 180,   # 90 pixel ea
  3: 210,   # 70 pixel ea
  4: 232,   # 58 pixel ea (unused)
  5: 250,   # 50 pixel ea
  6: 264,   # 44 pixel ea (unused)
  7: 280,   # 40 pixel ea
  8: 296,   # 37 pixel ea (unused)
  9: 315,   # 35 pixel ea
  10: 330,  # 33 pixel ea (unused)
  11: 341,  # 31 pixel ea
}

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


# Get the position of my centre, using global coords.
func global_centre(node: Node) -> Vector2:
  var global_rect = global_rect(node)
  var global_centre = global_rect.position + global_rect.size / 2
  return global_centre


func get_child_with_name(node: Node, name: String) -> Node:
  for child: Node in node.get_children():
    if child.name == name:
      return child
  assert(false)
  return null   # Make the compiler happy :)
  
  
func parent_center(node: Node) -> Vector2:
  assert(node.has_method('get_parent') and node.has_method('get_parent_area_size'))
  return node.get_parent_area_size() * node.get_parent().scale / 2


func scale_to_width(node: Control, pixels: int) -> void:
  assert(node.size.x == node.size.y)
  var scene_width: float = node.size.x
  var new_scale_scalar: float = pixels / scene_width
  node.scale = Vector2(new_scale_scalar, new_scale_scalar)


func delete_node(node: Node) -> void:
  # Godot's version of deleting a node.
  if not node:
    return
  if node.has_method('get_parent') and node.get_parent():
    node.get_parent().remove_child(node)
  node.queue_free()

################################### Grid operations ##########################################

# The first coord is row #, the second is column #.
func index_to_coords(idx: int, size: int) -> Vector2:
  return Vector2(idx / size, idx % size)
  
  
func coords_to_index(coords: Vector2, size: int) -> int:
  if (coords.x < 0 or coords.y < 0 or
      coords.x >= size or coords.y >= size):
    return -1
  var idx: float = coords.x * size + coords.y
  assert(int(idx) == idx)
  return int(idx)


const TOUCHING: Array[Vector2] = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, -1), Vector2(0, 1)]
func touching() -> Array[Vector2]:
  return TOUCHING


func around_me(width: int) -> Array[Vector2]:
  assert(width % 2 == 1)
  var start_idx = -(width / 2)
  var ret: Array[Vector2] = []
  for i in width:
    for j in width:
      ret.append(Vector2(start_idx + i, start_idx + j))
  assert(len(ret) == width ** 2)
  return ret
  

func affected_region(rarity: int) -> Array[Vector2]:
  var affected_region: Array[Vector2]
  match rarity:
    2:
      affected_region = Util.touching()
    3:
      affected_region = Util.around_me(3)
    _:
      affected_region = []
  return affected_region

################################### Math operations ##########################################

func sum(array: Array[float]) -> float:
  return array.reduce(func(x, y): return x + y, 0.0)

extends Control

@export var grid_container : Node
@export var Tile : PackedScene
@export var TwoDCubie : PackedScene
@export var Draggable : PackedScene

const GRID_PIXELS = {
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

# grid_size is the number of tiles along one edge of the grid.
var grid_size : int = 3
var grid_cubies : Array[int] = [0, 0, 2, 0, 1, 0, 3, 0, 1]


# TODO: fix this function. This is horrible.
func set_cubie(position: int, rarity: int) -> void:
  assert(0 <= position and position < grid_size ** 2)
  assert(len(grid_cubies) == grid_size ** 2)
  
  grid_cubies[position] = rarity
  # Zero means no cubie :(
  if rarity == 0:
    return
  
  # Create the new 2DCubie.
  var new_cubie : Node = TwoDCubie.instantiate()
  new_cubie.size = Vector2(440, 440)    # Gross...
  new_cubie.z_index = 1   # The cubie needs to be in front of the tile.
  new_cubie.set_colour(rarity)
  # Make it draggable.
  var draggable : Node = Draggable.instantiate()
  new_cubie.add_child(draggable)
  # Register the Draggable signal.
  draggable.released.connect(_on_drag_release)
  # Add the cubie.
  # GridContainer -> TileParent -> Tile -> TileShape -> [2DCubie -> Draggable]
  grid_container.get_child(position).get_child(0).get_child(0).add_child(new_cubie)   # Gross...


func generate_children(new_grid_size : int) -> void:
  # Programmatically create a TileParent.
  var new_tile_parent : Node = Control.new()
  var new_tile : Node = Tile.instantiate()
  new_tile_parent.add_child(new_tile)

  # Recompute the number of tile instances.
  for tile_parent in grid_container.get_children():
    Util.delete_node(tile_parent)
  for i in new_grid_size ** 2:
    var tile_parent : Node = new_tile_parent.duplicate()
    # TileParent -> Tile
    tile_parent.get_child(0).tile_idx = i
    grid_container.add_child(tile_parent)
  Util.delete_node(new_tile_parent)


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


func update_cubies(new_grid_size : int) -> void:
  # We assume the grid only gets bigger in normal play.
  # If the new grid is smaller, cubies are intentionally lost.
  assert(len(grid_cubies) > 0)
  # Assert perfect square number of cubies.
  assert(sqrt(len(grid_cubies)) ** 2 == len(grid_cubies))

  var old_grid_size : int = int(sqrt(len(grid_cubies)))

  # Replace the old array with one filled with 0s.
  var new_cubies : Array[int] = []
  for i : int in new_grid_size ** 2:
    new_cubies.append(0)
  var old_cubies : Array[int] = grid_cubies
  grid_cubies = new_cubies
  
  # Populate the new array with set_cubie().
  for i : int in new_grid_size ** 2:
    var new_coords : Vector2 = index_to_coords(i, new_grid_size)
    var old_coords : Vector2 = Vector2(new_coords.x - (new_grid_size - old_grid_size) / 2,
                                       new_coords.y - (new_grid_size - old_grid_size) / 2)
    var old_idx : int = coords_to_index(old_coords, old_grid_size)
    if 0 <= old_idx and old_idx < old_grid_size ** 2:
      set_cubie(i, old_cubies[old_idx])
    else:
      set_cubie(i, 0)
      
      
func update_scale(node: Control, pixels: int) -> void:
  assert(node.size.x == node.size.y)
  var scene_width : float = node.size.x
  var new_scale_scalar : float = pixels / scene_width
  node.scale = Vector2(new_scale_scalar, new_scale_scalar)


func center_self() -> void:
  var parent_center : Vector2 = self.get_parent_area_size() * self.get_parent().scale / 2
  var my_size : Vector2 = self.size * self.scale
  self.position = parent_center - my_size / 2


func update_params(new_grid_size : int) -> void:
  # The updates below need to be in this order. It goes from innermost to
  # outermost.

  # Update the scale of every Tile, 2DCubie, and TileShape.
  var pixels_per_tile : int = GRID_PIXELS[new_grid_size] / new_grid_size
  for tile_parent : Node in grid_container.get_children():
    for child in tile_parent.get_children():
      update_scale(child, pixels_per_tile)
    tile_parent.custom_minimum_size = Vector2(pixels_per_tile, pixels_per_tile)
    
  # Update sizes first.
  grid_container.size = Vector2(GRID_PIXELS[new_grid_size], GRID_PIXELS[new_grid_size])
  self.size = Vector2(GRID_PIXELS[new_grid_size], GRID_PIXELS[new_grid_size])
  
  # Update position second.
  grid_container.position = Vector2(0, 0)
  self.center_self()


func set_grid_size(new_grid_size : int) -> void:
  assert(3 <= new_grid_size and new_grid_size <= 11)
  grid_size = new_grid_size
  grid_container.columns = grid_size

  generate_children(new_grid_size)
  update_cubies(new_grid_size)
  update_params(new_grid_size)
  

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


# TODO: delete. Just for test purposes.
func _on_option_button_item_selected(index: int) -> void:
  # 0 -> 3, 1 -> 5, etc.
  self.set_grid_size(2 * index + 3)


func _on_drag_release(node: Node, initial_pos: Vector2) -> void:
  # We only care about signals for the cubies in the grid.
  if not grid_container.is_ancestor_of(node):
    return

  # 2DCubie -> TileShape -> Tile
  var current_tile = node.get_parent().get_parent()
  var current_idx = current_tile.tile_idx
  # All computations are done with global positions.
  var global_scale = Util.global_scale(node)
  var global_rect = Util.global_rect(node)
  var global_centre = global_rect.position + global_rect.size / 2
  # Look through all the tiles and see if I've landed in one.
  for tile_parent in grid_container.get_children():
    var new_tile = tile_parent.get_child(0)
    # We only care if it's a new Tile...
    if current_idx == new_tile.tile_idx:
      continue
    # If I land in a new Tile, move me over to the new Tile.
    if Util.global_rect(new_tile).has_point(global_centre):
      set_cubie(new_tile.tile_idx, grid_cubies[current_idx])
      set_cubie(current_idx, 0)
      Util.delete_node(node)
      return
  # If we didn't land in a Tile, then put us back in our Tile.
  node.position = initial_pos

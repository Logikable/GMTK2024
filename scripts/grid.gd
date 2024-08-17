extends Control

@export var grid_container : Node
@export var Tile : PackedScene
# grid_size is the number of tiles along one edge of the grid.
var grid_size = 1
var grid_pixels = {
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.set_grid_size(11)


func center_self() -> void:
  var parent_center = self.get_parent_area_size() / 2
  var my_size = self.size
  self.position = parent_center - my_size / 2


func set_grid_size(new_grid_size : int) -> void:
  assert(3 <= new_grid_size and new_grid_size <= 11)
  grid_size = new_grid_size

  # Programmatically create a TileParent.
  var new_tile_parent = Control.new()
  var new_tile = Tile.instantiate()
  new_tile_parent.add_child(new_tile)

  # Recompute the number of tile instances.
  for tile_parent in grid_container.get_children():
    # Godot's version of deleting a node.
    grid_container.remove_child(tile_parent)
    tile_parent.queue_free()
  for i in grid_size * grid_size:
    grid_container.add_child(new_tile_parent.duplicate())
  new_tile_parent.queue_free()

  # Update column count.
  grid_container.columns = grid_size

  # The updates below need to be in this order. It goes from innermost to
  # outermost.

  # Update the scale of every Tile and TileShape.
  var pixels_per_tile = grid_pixels[grid_size] / grid_size
  for tile_parent in grid_container.get_children():
    tile_parent.get_child(0).update_scale(pixels_per_tile)
    tile_parent.custom_minimum_size = Vector2(pixels_per_tile, pixels_per_tile)
    
  # Update sizes first.
  grid_container.size = Vector2(grid_pixels[grid_size], grid_pixels[grid_size])
  self.size = Vector2(grid_pixels[grid_size], grid_pixels[grid_size])
  
  # Update position second.
  grid_container.position = Vector2(0, 0)
  self.center_self()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


# TODO: delete. Just for test purposes.
func _on_option_button_item_selected(index: int) -> void:
  self.set_grid_size(2 * index + 3)

extends Control

@export var grid_container : Node
# grid_size is the number of tiles along one edge of the grid.
var grid_size = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  self.set_grid_size(8)


func set_grid_size(new_grid_size : int) -> void:
  grid_size = new_grid_size
  # Update the GridContainer.
  grid_container.columns = new_grid_size
  # When the grid size is updated, re-draw the tiles.
  # This node will be duplicated to create the new nodes.
  var cloned_tile_node = grid_container.get_child(0).duplicate()
  for tile_node in grid_container.get_children():
    # Godot's version of deleting a node.
    tile_node.queue_free()
  for i in grid_size * grid_size:
    grid_container.add_child(cloned_tile_node.duplicate())
  cloned_tile_node.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

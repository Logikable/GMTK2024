extends Control

@export var Card: PackedScene
@export var Tile: PackedScene
@export var TwoDCubie: PackedScene

var grid: Node
# Whether we're a 2DCubie or a Card.
var is_2dcubie : bool = false


func become_2dcubie():
  # Before: CardParent -> Draggable, Card.
  # After: CardParent -> Draggable, (Tile -> TileShape -> 2DCubie).
  var card: Node = Util.get_child_with_name(self, 'Card')   # Gross...
  var rarity: int = card.rarity
  # Remove the card.
  Util.delete_node(card)

  # Add a Tile -> TileShape -> 2DCubie.
  var new_cubie: Node = TwoDCubie.instantiate()
  new_cubie.z_index = 1   # The cubie needs to be in front of tiles.
  new_cubie.set_colour(rarity)
  var new_tile: Node = Tile.instantiate()
  new_tile.get_child(0).add_child(new_cubie)
  self.add_child(new_tile)

  # Scale the Tile.
  var cubie_width = Util.GRID_PIXELS[grid.grid_size] / grid.grid_size
  Util.scale_to_width(new_tile, cubie_width)
  # Set the size of the CardParent.
  self.custom_minimum_size = Vector2(cubie_width, cubie_width)
  self.size = Vector2(cubie_width, cubie_width)

  # Center the cube on the cursor.
  var draggable: Node = Util.get_child_with_name(self, 'Draggable')    # Gross...
  draggable.initial_click_position = draggable.initial_global_pos + self.size / 2

  # We are now a 2DCubie.
  is_2dcubie = true


func become_card() -> void:
  # Before: CardParent -> Draggable, (Tile -> TileShape -> 2DCubie).
  # After: CardParent -> Draggable, Card.
  var tile: Node = Util.get_child_with_name(self, 'Tile')   # Gross...
  var rarity: int = tile.get_child(0).get_child(0).rarity   # Tile -> TileShape -> 2DCubie.
  # Remove the tile.
  Util.delete_node(tile)
  
  var new_size: Vector2 = Vector2(176, 176)   # Gross...
  # Add a Card and scale it properly.
  var card: Node = Card.instantiate()
  card.set_rarity(rarity)
  Util.scale_to_width(card, new_size.x)
  self.add_child(card)
  
  # Set the size of the CardParent.
  self.custom_minimum_size = new_size
  self.size = new_size

  # We are no longer a 2DCubie.
  is_2dcubie = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  grid = get_tree().get_first_node_in_group('grid')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

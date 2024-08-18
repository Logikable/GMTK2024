extends TabContainer

@export var alchemy_cards: Node
@export var grid: Node
@export var CardParent: PackedScene
@export var Card: PackedScene
@export var Tile: PackedScene
@export var TwoDCubie: PackedScene

const COLOURS = {
  'SHOP': { 'bg': 'FFFAE0', 'border': 'FFEE93' },
  'ALCHEMY': { 'bg': 'F4E9FF', 'border': 'CB93FF' },
  'BLESSINGS': { 'bg': 'E0FDFF', 'border': '92F8FF' }
}
const STYLEBOXES = ['panel', 'tab_selected']


func set_menu_colours(name: String) -> void:
  var colours = COLOURS[name]

  for stylebox in STYLEBOXES:
    var stylebox_clone = self.get_theme_stylebox(stylebox).duplicate()
    stylebox_clone.bg_color = Color.html(colours.bg)
    stylebox_clone.border_color = Color.html(colours.border)
    add_theme_stylebox_override(stylebox, stylebox_clone)


func add_alchemy_card() -> void:
  # Add a card (parent) to the list of alchemy cards.
  var card_parent: Node = CardParent.instantiate()
  card_parent.is_2dcubie = false

  # Register the Draggable's signals with the menu's handlers.
  var draggable: Node = Util.get_child_with_name(card_parent, 'Draggable')    # Gross...
  draggable.moved.connect(_on_card_moved)
  draggable.released.connect(_on_drag_release)
  
  # Set the card's rarity.
  var card: Node = Util.get_child_with_name(card_parent, 'Card')   # Gross...
  card.set_rarity(1)

  alchemy_cards.add_child(card_parent)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Programmatically generate all the alchemy cards.
  # Remove existing cards.
  for child in alchemy_cards.get_children():
    Util.delete_node(child)
  add_alchemy_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_tab_changed(tab: int) -> void:
  var tab_name = self.get_tab_title(tab)
  set_menu_colours(tab_name)


# TODO: delete; button is not necessary.
func _on_card_add_button_press() -> void:
  add_alchemy_card()


# If we exit the menu, turn the Card in the CardParent into a 2DCubie.
func _on_card_moved(node: Node, global_pos: Vector2) -> void:
  # We only care about signals for the cards in the menu.
  if not self.is_ancestor_of(node):
    return

  # Ignore when we're still in the menu.
  if self.get_rect().has_point(global_pos):
    return
  # Ignore if we're already a 2DCubie.
  if node.is_2dcubie:
    return

  # Before: CardParent -> Draggable, Card.
  # After: CardParent -> Draggable, (Tile -> TileShape -> 2DCubie).
  var card: Node = Util.get_child_with_name(node, 'Card')   # Gross...
  var rarity: int = card.rarity
  # Remove the card.
  Util.delete_node(card)

  # Add a Tile -> TileShape -> 2DCubie.
  var new_cubie: Node = TwoDCubie.instantiate()
  new_cubie.z_index = 1   # The cubie needs to be in front of tiles.
  new_cubie.set_colour(rarity)
  var new_tile: Node = Tile.instantiate()
  new_tile.get_child(0).add_child(new_cubie)
  node.add_child(new_tile)

  # Scale the Tile.
  var cubie_width = Util.GRID_PIXELS[grid.grid_size] / grid.grid_size
  Util.scale_to_width(new_tile, cubie_width)
  # Set the size of the CardParent.
  node.custom_minimum_size = Vector2(cubie_width, cubie_width)
  node.size = Vector2(cubie_width, cubie_width)

  # Center the cube on the cursor.
  var draggable: Node = Util.get_child_with_name(node, 'Draggable')    # Gross...
  draggable.initial_click_position = draggable.initial_global_pos + node.size / 2

  # We are now a 2DCubie.
  node.is_2dcubie = true


func _on_drag_release(node: Node, initial_pos: Vector2) -> void:
  # We only care about signals for the cards in the menu.
  if not self.is_ancestor_of(node):
    return

  # Put us back in our position in the parent.
  node.position = initial_pos

  # Reset us back to a card.
  # Before: CardParent -> Draggable, (Tile -> TileShape -> 2DCubie).
  # After: CardParent -> Draggable, Card.
  var tile: Node = Util.get_child_with_name(node, 'Tile')   # Gross...
  var rarity: int = tile.get_child(0).get_child(0).rarity   # Tile -> TileShape -> 2DCubie.
  # Remove the tile.
  Util.delete_node(tile)
  
  # Create a new CardParent to get the proper sizes...
  var new_size: Vector2 = CardParent.instantiate().size
  # Add a Card and scale it properly.
  var card: Node = Card.instantiate()
  card.set_rarity(rarity)
  Util.scale_to_width(card, new_size.x)
  node.add_child(card)
  
  # Set the size of the CardParent.
  node.custom_minimum_size = new_size
  node.size = new_size

  # We are no longer a 2DCubie.
  node.is_2dcubie = false

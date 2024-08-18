extends TabContainer

@export var alchemy_cards: Node
@export var CardParent: PackedScene

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
  node.become_2dcubie()


func _on_drag_release(node: Node, initial_pos: Vector2) -> void:
  # We only care about signals for the cards in the menu.
  if not self.is_ancestor_of(node):
    return

  # Put us back in our position in the parent.
  node.position = initial_pos

  # Reset us back to a card.
  node.become_card()

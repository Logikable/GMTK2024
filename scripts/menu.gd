extends TabContainer

@export var alchemy_cards: Node
@export var grid: Node
@export var shop_rows: Node
@export var CardParent: PackedScene
@export var Upgrade: PackedScene

const MENU_COLOURS = {
  'SHOP': { 'bg': 'FFFAE0', 'border': 'FFEE93' },
  'ALCHEMY': { 'bg': 'F4E9FF', 'border': 'CB93FF' },
  'BLESSINGS': { 'bg': 'E0FDFF', 'border': '92F8FF' }
}
const MENU_STYLEBOXES = ['panel', 'tab_selected']

const SHOP_ROWS: int = 2
const SHOP_COLUMNS: int = 7
const SHOP_UPGRADE_SIZE: Vector2 = Vector2(100, 100)

var game: Node
var available_upgrades = []


func set_menu_colours(name: String) -> void:
  var colours = MENU_COLOURS[name]

  for stylebox in MENU_STYLEBOXES:
    var stylebox_clone = self.get_theme_stylebox(stylebox).duplicate()
    stylebox_clone.bg_color = Color.html(colours.bg)
    stylebox_clone.border_color = Color.html(colours.border)
    add_theme_stylebox_override(stylebox, stylebox_clone)
    
    
func add_shop_upgrade(id: float) -> void:
  assert(id not in available_upgrades)
  
  # Sort the list of available upgrades and remake the shop.
  available_upgrades.append(id)
  available_upgrades.sort()
  recreate_shop()
  
  
func recreate_shop() -> void:
  # Remove all UpgradeParents.
  for columns in shop_rows.get_children():
    for child in columns.get_children():
      Util.delete_node(child)
  
  # Generate all the UpgradeParents.
  var upgrade_parents: Array = []
  for id in available_upgrades:
    var upgrade: Dictionary = Upgrades.UPGRADES_DICT[id]
    # Create UpgradeNode.
    var upgrade_node: Node = Upgrade.instantiate()
    upgrade_node.id = id
    # Set visuals.
    upgrade_node.button.tooltip_text = upgrade.tooltip
    upgrade_node.set_upgrade_count(0)
    upgrade_node.upgrade_icon.texture = load(upgrade.icon)
    upgrade_node.scale = SHOP_UPGRADE_SIZE / upgrade_node.size
    
    # Link its button with menu's handler.
    upgrade_node.button.pressed.connect(_on_shop_upgrade_button_press.bind(upgrade_node))
    
    # Create UpgradeParent.
    var upgrade_parent: Node = Control.new()
    upgrade_parent.add_child(upgrade_node)
    upgrade_parent.custom_minimum_size = SHOP_UPGRADE_SIZE
    
    upgrade_parents.append(upgrade_parent)
  assert(len(upgrade_parents) == len(available_upgrades))
    
  # Add them into the shop.
  for i in len(upgrade_parents):
    shop_rows.get_child(i / SHOP_COLUMNS).add_child(upgrade_parents[i])


func add_alchemy_card(rarity: int) -> void:
  # Add a card (parent & grandparent) to the list of alchemy cards.
  var card_parent: Node = CardParent.instantiate()
  card_parent.is_2dcubie = false

  # Register the Draggable's signals with the menu's handlers.
  var draggable: Node = Util.get_child_with_name(card_parent, 'Draggable')    # Gross...
  draggable.moved.connect(_on_card_moved)
  draggable.released.connect(_on_drag_release)
  
  # Set the card's rarity.
  var card: Node = Util.get_child_with_name(card_parent, 'Card')   # Gross...
  card.set_rarity(rarity)

  # Create a grandparent node that can maintain its size and act as a placeholder
  # after we've moved.
  var card_grandparent: Node = Control.new()
  card_grandparent.custom_minimum_size = card_parent.size
  card_grandparent.add_child(card_parent)

  alchemy_cards.add_child(card_grandparent)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  game = get_tree().get_first_node_in_group('game')
  # We programmatically generate all the alchemy cards, so remove existing cards.
  for child in alchemy_cards.get_children():
    Util.delete_node(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_tab_changed(tab: int) -> void:
  var tab_name = self.get_tab_title(tab)
  set_menu_colours(tab_name)


func _on_shop_upgrade_button_press(node: Node) -> void:
  game.try_upgrade(node)


# TODO: delete; button is not necessary.
func _on_card_add_button_press() -> void:
  add_alchemy_card(1)


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
  # If we're not in 2DCubie mode, then we only need to reset our position.
  if not node.is_2dcubie:
    node.position = initial_pos
    return
  
  # CardParent -> Draggable, (Tile -> TileShape -> 2DCubie)
  var rarity: int = Util.get_child_with_name(node, 'Tile').get_child(0).get_child(0).rarity
  # All computations are done with global positions.
  var global_centre: Vector2 = Util.global_centre(node)

  # Look through all the tiles and see if I've landed in one.
  for tile_parent: Node in grid.grid_container.get_children():
    var tile: Node = tile_parent.get_child(0)
    # We only care if we land in this new Tile.
    if not Util.global_rect(tile).has_point(global_centre):
      continue
    # Ignore if there's already a Tile here. In fact, we can break early.
    if grid.grid_cubies[tile.tile_idx] != 0:
      break
    # Put the cubie in the Tile.
    grid.set_cubie(tile.tile_idx, rarity)
    # Delete the CardParent and CardGrandparent.
    Util.delete_node(node.get_parent())
    return

  # Put us back in our position in the parent.
  node.position = initial_pos
  # Reset us back to a card.
  node.become_card()


func _on_upgrades_updated(id: float) -> void:
  var upgrade: Dictionary = Upgrades.UPGRADES_DICT[id]
  if upgrade.type == Upgrades.UpgradeType.CUBIE:
    add_alchemy_card(upgrade.rarity)

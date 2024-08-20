extends Control

@export var cps_label: Label
@export var cubies_label: Label
@export var grid: Node
@export var menu: Node
@export var right_node: Node
@export var BGCubie: PackedScene

# Bump this whenever the save file changes.
const VERSION = 0.2
const BASE_INITIAL_CUBIE_CLICK = 1.0
const BASE_CPS: Dictionary = { -1: 0.0, 0: 0.0, 1: 1.0, 2: 0.0, 3: 0.0, 4: 0.0 }
const BASE_MULT: Dictionary = { -1: 0.0, 0: 0.0, 1: 1.0, 2: 2.0, 3: 1.1, 4: 0.0 }
const SUPERCHARGE_COOLDOWN: float = 5 * 60.0
const SUPERCHARGE_DURATION: float = 10.0
const AUTOSAVE_COOLDOWN: float = 30.0

var cubies: float
var cubies_all_time: float
var supercharge_cooldown_remaining: float
var supercharge_duration_remaining: float
var autosave_cooldown_remaining: float
# Upgrade ID -> Integer.
var upgrades_owned: Dictionary = {}
  

func add_cubies(cubies_: float) -> void:
  cubies += cubies_
  cubies_all_time += cubies_


# The handling of supercharge is everywhere. It's not pretty.
func maybe_supercharge(v: float) -> float:
  var supercharge_multiplier = 2.0 if (supercharge_duration_remaining > 0.0) else 1.0
  return v * supercharge_multiplier

# TODO
# We should add some kind of quick scale tween to the initial cubie
# when you click it, that way we get more visual feedback. I couldn't
# find the actual node for it so I couldn't manage to tween it :(

func initial_cubie_click() -> void:
  # Determine how many cubies to accumulate.
  var width = grid.grid_size
  var area = len(grid.grid_cubies)
  # Compute additive effects.
  var cubies_generated = BASE_INITIAL_CUBIE_CLICK
  for upgrade in Upgrades.UPGRADES_BY_TYPE[Upgrades.UpgradeType.CLICK]:
    cubies_generated += upgrade.additive_click_power * times_purchased(upgrade.id)
  # Compute multiplicative effects of grid cubies.
  for idx in area:
    var rarity: int = grid.grid_cubies[idx]
    var affected_region: Array[Vector2] = Util.affected_region(rarity)
    var coords = Util.index_to_coords(idx, width)
    for delta: Vector2 in affected_region:
      var affected_idx = Util.coords_to_index(coords + delta, width)
      if affected_idx == grid.initial_cubie_idx:
        cubies_generated *= maybe_supercharge(BASE_MULT[rarity])
        
    # Add cubie to background when clicking.
    for cubie in cubies_generated:
      var bg_cubie = BGCubie.instantiate()
      right_node.add_child(bg_cubie)
  
  

func cubies_per_second() -> float:
  var width = grid.grid_size
  var area = len(grid.grid_cubies)
  
  var cps_per_tile: Array[float] = []
  # First, populate with base cps values.
  for idx in area:
    var rarity: int = grid.grid_cubies[idx]
    var cps: int = maybe_supercharge(BASE_CPS[rarity])
    cps_per_tile.append(cps)
  assert(len(cps_per_tile) == area)

  # Find and handle multiplicative cubies (rarity 2 and 3).
  for idx in area:
    var rarity: int = grid.grid_cubies[idx]
    var affected_region: Array[Vector2] = Util.affected_region(rarity)
    var coords = Util.index_to_coords(idx, width)
    for delta: Vector2 in affected_region:
      var affected_idx = Util.coords_to_index(coords + delta, width)
      if 0 <= affected_idx and affected_idx < area:
        cps_per_tile[affected_idx] *= maybe_supercharge(BASE_MULT[rarity])

  return Util.sum(cps_per_tile)


func times_purchased(id: float) -> int:
  if id in upgrades_owned:
    return upgrades_owned[id]
  return 0  


func try_upgrade(node: Node) -> void:
  var upgrade: Dictionary = Upgrades.UPGRADES_DICT[node.id]
  # Compute cost and whether we can afford it.
  var times_purchased: int = times_purchased(node.id)
  var cost: float = Upgrades.cost(node.id, times_purchased)
  if cost > cubies:
    return
  
  # Buy it since we can afford it.
  cubies -= cost
  times_purchased += 1
  upgrades_owned[node.id] = times_purchased

  # If we've reached the purchase limit, remove it from available upgrades.
  if times_purchased >= upgrade.purchase_limit and upgrade.purchase_limit >= 0:
    menu.remove_shop_upgrade(node.id)

  # Handle the upgrade's effects.
  match upgrade.type:
    Upgrades.UpgradeType.EXPANSION:
      grid.set_grid_size(upgrade.new_grid_size)
    Upgrades.UpgradeType.CUBIE:
      menu.add_alchemy_card(upgrade.rarity)
    _:
      pass


func save_data() -> Dictionary:
  return {
    'version': VERSION,
    'cubies': cubies,
    'cubies_all_time': cubies_all_time,
    'upgrades_owned': upgrades_owned,
    'available_upgrades': menu.available_upgrades,
    'available_cards': menu.available_cards,
    'grid_size': grid.grid_size,
    'grid_cubies': grid.grid_cubies,
    'supercharge_cooldown_remaining': supercharge_cooldown_remaining,
    'supercharge_duration_remaining': supercharge_duration_remaining,
  }


func load_data(data: Dictionary) -> void:
  # For now, we don't support cross-version saves.
  if data.version != VERSION:
    return
  cubies = data.cubies
  cubies_all_time = data.cubies_all_time
  upgrades_owned = data.upgrades_owned
  menu.set_shop_upgrades(data.available_upgrades)
  menu.set_alchemy_cards(data.available_cards)
  grid.set_grid_size(data.grid_size)
  grid.set_grid_cubies(data.grid_cubies)
  supercharge_cooldown_remaining = data.supercharge_cooldown_remaining
  supercharge_duration_remaining = data.supercharge_duration_remaining
  print('game.load_data(): Game loaded.')


func autosave(delta: float) -> void:
  autosave_cooldown_remaining = max(0.0, autosave_cooldown_remaining - delta)
  if autosave_cooldown_remaining == 0:
    SaveFile.save_to_disk(save_data())
    autosave_cooldown_remaining = AUTOSAVE_COOLDOWN
    print('game.autosave(): Game autosaved.')


func reset_game() -> void:
  cubies = 0
  cubies_all_time = 0
  upgrades_owned = {}
  menu.reset_shop_upgrades()
  menu.reset_alchemy_cards()
  grid.set_grid_size(1)
  grid.set_grid_cubies([-1])
  supercharge_cooldown_remaining = 0.0
  supercharge_duration_remaining = 0.0
  print('game.reset_game(): Game reset.')


func compute_new_cubies(delta: float) -> void:
  # Update CPS and Cubies counter.
  var cps = cubies_per_second()
  add_cubies(cps * delta)
  # Display CPS with 1 decimal.
  cps_label.text = str(floori(cps * 10.0) / 10.0) + ' cubies/s'
  cubies_label.text = str(floori(cubies)) + ' cubies'


func update_supercharge_timers(delta: float) -> void:
  # Handle rarity=4 cubies doing supercharge.
  supercharge_cooldown_remaining = max(0.0, supercharge_cooldown_remaining - delta)
  supercharge_duration_remaining = max(0.0, supercharge_duration_remaining - delta)
  
  if supercharge_cooldown_remaining == 0.0 and grid.grid_cubies.has(4):
    supercharge_cooldown_remaining = SUPERCHARGE_COOLDOWN
    supercharge_duration_remaining = SUPERCHARGE_DURATION


func update_shop() -> void:
  for upgrade in Upgrades.UPGRADES:
    # Don't add upgrades already in the menu.
    if upgrade.id in menu.available_upgrades:
      continue
    # Don't add the upgrade if we're at the purchase limit.
    if upgrade.id in upgrades_owned and upgrades_owned[upgrade.id] >= upgrade.purchase_limit:
      continue
    # Don't add the upgrade if we can't afford it.
    if upgrade.unlock_at > cubies:
      continue
    # Don't add the upgrade if we don't have the prerequisite upgrades.
    if not Upgrades.has_prerequisites(upgrade.id, upgrades_owned):
      continue
    menu.add_shop_upgrade(upgrade.id)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  autosave_cooldown_remaining = AUTOSAVE_COOLDOWN
  if SaveFile.can_load():
    load_data(SaveFile.load_from_disk())
  else:
    # If we don't have a save to load from, set their default values.
    reset_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var old_cubies: float = cubies
  compute_new_cubies(delta)
  update_supercharge_timers(delta)
  update_shop()

  # If the number of cubies crossed an integer barrier, spawn a BGCubie.
  if floor(cubies) > floor(old_cubies):
    var bg_cubie: Node = BGCubie.instantiate()
    right_node.add_child(bg_cubie)
  
  


func _make_custom_tooltip(for_text):
  var tooltip = preload("res://scenes/tooltip.tscn").instantiate()
  tooltip.get_node("MarginContainer/BodyText").text = for_text
  return tooltip


func _on_save_button_pressed() -> void:
  SaveFile.save_to_disk(save_data())


func _on_load_button_pressed() -> void:
  if SaveFile.can_load():
    load_data(SaveFile.load_from_disk())


func _on_reset_save_button_pressed() -> void:
  reset_game()
  SaveFile.save_to_disk(save_data())

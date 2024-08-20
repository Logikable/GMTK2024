extends Node

enum UpgradeType {
  EXPANSION = 1,
  CUBIE = 2,
  ZONE = 3,
  CLICK = 11,
  IMPROVE_CUBIE = 12,
  OTHER = 101,
}

# Upgrade IDs are floats. The ordering of the upgrades in the shop are dependent
# on the ID. They're floats so we can arbitrarily insert between any two
# upgrades.
# The hundredths digit is the UpgradeType.
# The ones digit is the ID within that type.
# Any decimal digits are to insert between existing upgrades.
const UPGRADES: Array = [
  {
    'id': 101.0,
    'display_name': 'Expand Grid I',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 3,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 40,
    'unlock_requires': [[1101.0, 2]],
    'initial_cost': 60,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of the grid to 3x3',
  },
  {
    'id': 102.0,
    'display_name': 'Expand Grid II',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 5,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 3000,
    'unlock_requires': [[101.0, 1]],
    'initial_cost': 9000,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of the grid to 5x5',
  },
  {
    'id': 103.0,
    'display_name': 'Expand Grid III',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 7,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 6e6,
    'unlock_requires': [[102.0, 1]],
    'initial_cost': 18e6,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of the grid to 7x7',
  },
  {
    'id': 104.0,
    'display_name': 'Expand Grid IV',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 9,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 30e9,
    'unlock_requires': [[103.0, 1]],
    'initial_cost': 90e9,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of the grid to 9x9',
  },
  {
    'id': 105.0,
    'display_name': 'Expand Grid V',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 11,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 200e12,
    'unlock_requires': [[104.0, 1]],
    'initial_cost': 600e12,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of the grid to 11x11',
  },
  {
    'id': 201.0,
    'display_name': 'Cubie Alchemy Ticket',
    'type': UpgradeType.CUBIE,
    'rarity': 1,
    'icon': Util.CUBIE_SHOP_ICON[1],
    'unlock_at': 15,
    'unlock_requires': [[101.0, 1]],
    'initial_cost': 30,
    'cost_scaling': 1.71,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Add a Cubie to the Alchemy Supply',
  },
  {
    'id': 202.0,
    'display_name': 'Wowie Alchemy Ticket',
    'type': UpgradeType.CUBIE,
    'rarity': 2,
    'icon': Util.CUBIE_SHOP_ICON[2],
    'unlock_at': 250,
    'unlock_requires': [[201.0, 1]],
    'initial_cost': 750,
    'cost_scaling': 3.25,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Add a Wowie to the Alchemy Supply',
  },
  {
    'id': 203.0,
    'display_name': 'Aurie Alchemy Ticket',
    'type': UpgradeType.CUBIE,
    'rarity': 3,
    'icon': Util.CUBIE_SHOP_ICON[3],
    'unlock_at': 75e3,
    'unlock_requires': [[202.0, 1]],
    'initial_cost': 250e3,
    'cost_scaling': 5.46,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Add an Aurie to the Alchemy Supply',
  },
  {
    'id': 204.0,
    'display_name': 'Chargie Alchemy Ticket',
    'type': UpgradeType.CUBIE,
    'rarity': 4,
    'icon': Util.CUBIE_SHOP_ICON[4],
    'unlock_at': 500e6,
    'unlock_requires': [[203.0, 1]],
    'initial_cost': 1500e6,
    'cost_scaling': 17.09,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Add a Chargie to the Alchemy Supply',
  },
  {
    'id': 1101.0,
    'display_name': 'Improve Click Power I',
    'type': UpgradeType.CLICK,
    'additive_click_power': 0.5,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 10,
    'initial_cost': 15,
    'cost_scaling': 2.39,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Increase cubies per click by 0.5',
  },
]

# ID (float) -> Dictionary (of data)
var UPGRADES_DICT: Dictionary = {}
# UpgradeType Enum -> Array of Dictionaries (of data)
var UPGRADES_BY_TYPE: Dictionary = {}


func cost(id: float, times_purchased: int) -> float:
  var upgrade: Dictionary = Upgrades.UPGRADES_DICT[id]
  var cost: float = upgrade.initial_cost
  if 'cost_scaling' in upgrade:
    cost *= upgrade.cost_scaling ** times_purchased
  else:
    assert(times_purchased <= 1)
  return cost


func has_prerequisites(id: float, upgrades_owned: Dictionary) -> bool:
  var upgrade: Dictionary = Upgrades.UPGRADES_DICT[id]
  if 'unlock_requires' not in upgrade:
    return true
  for requirement in upgrade.unlock_requires:
    var required_id: float = requirement[0]
    var required_count: int = requirement[1]
    if required_id not in upgrades_owned:
      return false
    if upgrades_owned[required_id] < required_count:
      return false
  return true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Craft the derived lookup tables.
  for upgrade in UPGRADES:
    UPGRADES_DICT[upgrade.id] = upgrade
  for upgrade in UPGRADES:
    if upgrade.type not in UPGRADES_BY_TYPE:
      UPGRADES_BY_TYPE[upgrade.type] = []
    UPGRADES_BY_TYPE[upgrade.type].append(upgrade)

  # Sanity check.
  for upgrade in UPGRADES:
    assert('id' in upgrade)
    assert('display_name' in upgrade)
    assert('type' in upgrade)
    assert('icon' in upgrade)
    assert('unlock_at' in upgrade)
    assert('initial_cost' in upgrade)
    assert('purchase_limit' in upgrade)
    assert('tooltip' in upgrade)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

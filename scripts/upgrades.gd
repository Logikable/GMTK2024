extends Node

enum UpgradeType { EXPANSION = 1, CUBIE = 2, ZONE = 3, OTHER = 101, }

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
    'unlock_at': 5,
    'initial_cost': 10,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of your grid to 3x3.',
  },
  {
    'id': 102.0,
    'display_name': 'Expand Grid II',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 5,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 3000,
    'initial_cost': 9000,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of your grid to 5x5.',
  },
  {
    'id': 103.0,
    'display_name': 'Expand Grid III',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 7,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 6e6,
    'initial_cost': 18e6,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of your grid to 7x7.',
  },
  {
    'id': 104.0,
    'display_name': 'Expand Grid IV',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 9,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 30e9,
    'initial_cost': 90e9,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of your grid to 9x9.',
  },
  {
    'id': 105.0,
    'display_name': 'Expand Grid V',
    'type': UpgradeType.EXPANSION,
    'new_grid_size': 11,
    'icon': 'res://assets/cubies.png',   # TODO
    'unlock_at': 200e12,
    'initial_cost': 600e12,
    'purchase_limit': 1,
    'tooltip': 'Increase the size of your grid to 11x11.',
  },
  {
    'id': 201.0,
    'display_name': 'Buy Uncommon Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 1,
    'icon': Util.TEXTURE[1],
    'unlock_at': 13,
    'initial_cost': 13,
    'cost_scaling': 1.71,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Generates 1 cubie/s.',
  },
  {
    'id': 202.0,
    'display_name': 'Buy Rare Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 2,
    'icon': Util.TEXTURE[2],
    'unlock_at': 250,
    'initial_cost': 750,
    'cost_scaling': 3.25,
    'purchase_limit': -1,   # Infinite.
    'tooltip': '2x adjacent cubie output.',
  },
  {
    'id': 203.0,
    'display_name': 'Buy Epic Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 3,
    'icon': Util.TEXTURE[3],
    'unlock_at': 75e3,
    'initial_cost': 250e3,
    'cost_scaling': 5.46,
    'purchase_limit': -1,   # Infinite.
    'tooltip': '1.1x cubie output in a 3x3 radius.',
  },
  {
    'id': 204.0,
    'display_name': 'Buy Legendary Cube',
    'type': UpgradeType.CUBIE,
    'rarity': 4,
    'icon': Util.TEXTURE[4],
    'unlock_at': 500e6,
    'initial_cost': 1500e6,
    'cost_scaling': 17.09,
    'purchase_limit': -1,   # Infinite.
    'tooltip': 'Every 5 minutes, supercharges all cubes for 10 seconds.',
  },
]

var UPGRADES_DICT: Dictionary = {}

func cost(id: float, times_purchased: int) -> float:
  var upgrade: Dictionary = Upgrades.UPGRADES_DICT[id]
  var cost: float = upgrade.initial_cost
  if 'cost_scaling' in upgrade:
    cost *= upgrade.cost_scaling ** times_purchased
  else:
    assert(times_purchased <= 1)
  return cost


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  # Craft the upgrades_dict.
  for upgrade in UPGRADES:
    UPGRADES_DICT[upgrade.id] = upgrade
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
